{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.disk;

  subvol = mountpoint: {
    inherit mountpoint;
    mountOptions = [
      "compress=zstd"
      "noatime" # reduce unnecessary writes
    ];
  };

  btrfs = {
    type = "btrfs";
    extraArgs = [ "-f" ];

    subvolumes = {
      root = subvol "/";
      home = subvol "/home";
      nix = subvol "/nix";
    };
  };
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  options.myModules.disk = {
    enable = lib.mkEnableOption "disk partitioning" // {
      default = true;
    };

    encrypted = lib.mkEnableOption "LUKS encryption";

    device = lib.mkOption {
      type = lib.types.str;
      default = if cfg.encrypted then "/dev/nvme0n1" else "/dev/sda";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.e2fsprogs ]; # chattr/lsattr, only auto-added for ext filesystems

    services.btrfs.autoScrub.enable = true;

    systemd = {
      services.btrfs-stats = {
        description = "Check btrfs device error counters";
        path = with pkgs; [
          btrfs-progs
          dbus
        ];
        serviceConfig.Type = "oneshot";

        # systembus-notify relays this signal as a desktop popup
        script = ''
          if ! btrfs device stats --check /; then
            dbus-send --system / net.nuetzlich.SystemNotifications.Notify \
              'string:btrfs' 'string:Device errors on /, see: btrfs device stats /'
            exit 1
          fi
        '';
      };

      timers.btrfs-stats = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };

    disko.devices.disk.main = {
      inherit (cfg) device;
      type = "disk";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          ${if cfg.encrypted then "luks" else "root"} = {
            size = "100%";
            content =
              if cfg.encrypted then
                {
                  type = "luks";
                  name = "crypted";

                  settings = {
                    allowDiscards = true;
                    bypassWorkqueues = true;
                    crypttabExtraOpts = [ "tpm2-device=auto" ];
                  };

                  content = btrfs;
                }
              else
                btrfs;
          };
        };
      };
    };
  };
}

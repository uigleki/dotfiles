{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.myModules.disk;

  subvol = mountpoint: {
    inherit mountpoint;
    mountOptions = [
      "compress=zstd" # transparent compression
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
    services.btrfs.autoScrub.enable = true;

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

{ config, inputs, ... }:
let
  nixos = config.nixos.modules;

  subvol = mountpoint: {
    inherit mountpoint;

    mountOptions = [
      "compress=zstd"
      "noatime"
    ];
  };

  btrfs = {
    type = "btrfs";
    extraArgs = [ "-f" ];

    # disko creates these only at install; a host missing one drops to emergency mode at boot
    subvolumes = {
      root = subvol "/";
      nix = subvol "/nix";
      log = subvol "/var/log";
      persist = subvol "/persist";
      cache = subvol "/cache";
      snapshots = subvol "/snapshots";
    };
  };

  # hosts set disko.devices.disk.main.device
  common = {
    imports = [
      inputs.disko.nixosModules.disko
      nixos.btrfs
    ];

    disko.devices.disk.main.content = {
      type = "gpt";

      partitions.ESP = {
        size = "500M";
        type = "EF00";

        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
    };
  };
in
{
  nixos.modules = {
    disko-btrfs = {
      imports = [ common ];

      disko.devices.disk.main.content.partitions.root = {
        size = "100%";
        content = btrfs;
      };
    };

    disko-btrfs-luks = {
      imports = [ common ];

      disko.devices.disk.main.content.partitions.luks = {
        size = "100%";

        content = {
          type = "luks";
          name = "root";

          settings = {
            allowDiscards = true;
            bypassWorkqueues = true;
          };

          content = btrfs;
        };
      };
    };
  };
}

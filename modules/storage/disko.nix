{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;

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

  # hosts set disko.devices.disk.main.device
  common = {
    imports = [
      inputs.disko.nixosModules.disko
      nixos.btrfs
    ];

    disko.devices.disk.main = {
      type = "disk";

      content = {
        type = "gpt";

        partitions.ESP = {
          size = "500M";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountOptions = [ "umask=0077" ];
            mountpoint = "/boot";
          };
        };
      };
    };
  };
in
{
  flake.modules.nixos = {
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
          name = "crypted";

          settings = {
            allowDiscards = true;
            bypassWorkqueues = true;
            crypttabExtraOpts = [ "tpm2-device=auto" ];
          };

          content = btrfs;
        };
      };
    };
  };
}

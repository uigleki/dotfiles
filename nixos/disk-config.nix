{ lib, inputs, ... }:
let
  subvol = mountpoint: {
    mountOptions = [
      "compress=zstd"
      "noatime"
    ];
    inherit mountpoint;
  };
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  services.btrfs.autoScrub.enable = true;

  disko.devices = {
    disk.main = {
      device = lib.mkDefault "/dev/sda";
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
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "root" = subvol "/";
                "home" = subvol "/home";
                "nix" = subvol "/nix";
              };
            };
          };
        };
      };
    };
  };
}

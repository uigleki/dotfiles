{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.myModules.diskConfig;

  subvol = mountpoint: {
    inherit mountpoint;
    mountOptions = [
      "compress=zstd" # transparent compression
      "noatime" # reduce unnecessary writes
    ];
  };
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  options.myModules.diskConfig = {
    enable = lib.mkEnableOption "Enable disk configuration." // {
      default = true;
    };

    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/sda";
      example = "/dev/nvme0n1";
      description = "Device to use for disk configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.btrfs.autoScrub.enable = true;

    disko.devices = {
      disk.main = {
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
  };
}

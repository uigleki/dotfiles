# Secure Boot + TPM2 Full Disk Encryption
#
# This module provides:
# - Lanzaboote for Secure Boot with automatic key enrollment
# - LUKS-encrypted btrfs root with TPM2 auto-unlock support
# - Replaces standard boot and disk-config modules
#
# Post-install setup:
# 1. Enter BIOS, set Secure Boot to "Setup Mode", boot system
# 2. Lanzaboote auto-enrolls keys and reboots
# 3. Enroll TPM: sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 /dev/disk/by-partlabel/disk-main-luks

{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  subvol = mountpoint: {
    inherit mountpoint;
    mountOptions = [
      "compress=zstd"
      "noatime"
    ];
  };
in
{
  imports = with inputs; [
    disko.nixosModules.disko
    lanzaboote.nixosModules.lanzaboote
  ];

  myModules = {
    boot.enable = false;
    diskConfig.enable = false;
  };

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };

    # required for systemd-cryptenroll TPM unlock
    initrd.systemd.enable = true;
  };

  environment.systemPackages = [ pkgs.sbctl ];
  services.btrfs.autoScrub.enable = true;

  disko.devices.disk.main = {
    device = "/dev/nvme0n1";
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
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            settings = {
              allowDiscards = true;
              bypassWorkqueues = true;
              crypttabExtraOpts = [ "tpm2-device=auto" ];
            };
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

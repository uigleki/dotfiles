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
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.secureBoot;
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.myModules.secureBoot.enable = lib.mkEnableOption "Secure Boot with TPM2 FDE";

  config = lib.mkIf cfg.enable {
    myModules = {
      boot.enable = false;
      disk.encrypted = true;
    };

    boot = {
      initrd.systemd.enable = true; # required for systemd-cryptenroll TPM unlock

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
      };

      loader.systemd-boot.enable = lib.mkForce false;
    };

    environment.systemPackages = [ pkgs.sbctl ];
  };
}

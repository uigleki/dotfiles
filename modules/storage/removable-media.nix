{
  flake.modules.nixos.desktop = {
    boot.supportedFilesystems = [ "ntfs" ];

    services.udisks2.settings."mount_options.conf".defaults.btrfs_defaults = "compress=zstd,noatime";
  };
}

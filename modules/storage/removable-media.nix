{
  nixos.modules.desktop = {
    boot.supportedFilesystems = [ "ntfs" ];
    environment.persistence."/persist".directories = [ "/var/lib/udisks2" ];
    services.udisks2.settings."mount_options.conf".defaults.btrfs_defaults = "compress=zstd,noatime";
  };
}

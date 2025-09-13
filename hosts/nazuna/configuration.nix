{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot.loader = {
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    timeout = 0;
  };
}

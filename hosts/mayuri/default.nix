{ modulesPath, user, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../nixos/disk-config.nix
    ../../nixos/gui.nix
    ../../nixos/network.nix
  ];

  home-manager.users.${user.name} = {
    imports = [ ../../home/gui.nix ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}

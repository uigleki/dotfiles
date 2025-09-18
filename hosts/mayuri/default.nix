{ modulesPath, user, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  home-manager.users.${user.name} = {
    imports = [ ../../home/gui.nix ];
  };

  myModules.gui.enable = true;
}

{ user, ... }:
{
  imports = [ ../../nixos/wsl.nix ];

  home-manager.users.${user.name} = {
    myModules.dev.enable = true;
  };

  myModules = {
    boot.enable = false;
    diskConfig.enable = false;
    network.enable = false;
  };
}

{ user, ... }:
{
  imports = [ ../../nixos/wsl.nix ];

  myModules = {
    boot.enable = false;
    diskConfig.enable = false;
    network.enable = false;
  };

  home-manager.users.${user.name}.myModules.dev.enable = true;
}

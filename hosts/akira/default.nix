{ user, ... }:
{
  imports = [ ../../nixos/wsl.nix ];

  home-manager.users.${user.name}.myModules.dev.enable = true;
}

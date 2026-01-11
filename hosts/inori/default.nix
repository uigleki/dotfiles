{ user, ... }:
{
  myModules.wsl.enable = true;

  home-manager.users.${user.name}.myModules.dev.enable = true;
}

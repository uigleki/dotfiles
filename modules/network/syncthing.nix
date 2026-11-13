{
  nixos.modules.network =
    { config, ... }:
    {
      home-manager.users.${config.user.username}.services.syncthing.enable = true;
    };

  homeManager.modules.desktop.services.syncthing.tray.enable = true;
}

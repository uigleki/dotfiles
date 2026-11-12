{
  nixos.modules.network =
    { config, ... }:
    {
      home-manager.users.${config.owner.username}.services.syncthing.enable = true;
    };

  homeManager.modules.desktop.services.syncthing.tray.enable = true;
}

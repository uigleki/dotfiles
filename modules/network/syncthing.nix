{
  flake.modules = {
    nixos.network =
      { config, ... }:
      {
        home-manager.users.${config.owner.username}.services.syncthing.enable = true;
      };

    homeManager.desktop.services.syncthing.tray.enable = true;
  };
}

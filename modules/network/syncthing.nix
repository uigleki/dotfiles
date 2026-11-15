{
  nixos.modules.network =
    { config, ... }:
    {
      home-manager.users.${config.user.username} = {
        home.persistence."/persist".directories = [
          ".local/state/syncthing" # device keys; a new identity re-pairs every device
          "Sync" # the folders it shares
        ];

        services.syncthing.enable = true;
      };
    };

  homeManager.modules.desktop = {
    home.persistence."/persist".files = [
      # Qt replaces its settings by rename, which a bind-mounted file refuses
      {
        file = ".config/syncthingtray.ini";
        method = "symlink";
      }
    ];

    services.syncthing.tray.enable = true;
  };
}

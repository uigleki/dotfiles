{
  nixos.modules.network =
    { config, ... }:
    {
      home-manager.users.${config.user.username} = {
        home.persistence."/persist".directories = [
          ".local/state/syncthing" # device keys; a new identity re-pairs every device
          "Sync" # the folders it shares
        ];

        services.syncthing = {
          enable = true;

          # devices and folders come from the introducer
          overrideDevices = false;
          overrideFolders = false;

          settings.options = {
            crashReportingEnabled = false;
            urAccepted = -1;
          };
        };
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

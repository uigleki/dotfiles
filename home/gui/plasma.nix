{ config, ... }:
let
  syncDir = "${config.home.homeDirectory}/sync/a/";
  ubuntuFont = {
    family = "Ubuntu";
    pointSize = 10;
  };
  wallpapers = {
    path = syncDir + "images/wallpapers";
    interval = 3600;
  };
in
{
  programs = {
    plasma = {
      enable = true;

      fonts = {
        general = ubuntuFont;
        fixedWidth = ubuntuFont // {
          family = "Ubuntu Mono";
        };
        small = ubuntuFont // {
          pointSize = 8;
        };
        toolbar = ubuntuFont;
        menu = ubuntuFont;
        windowTitle = ubuntuFont;
      };

      powerdevil = {
        AC.autoSuspend.action = "nothing";
        battery.autoSuspend.action = "nothing";
      };

      hotkeys.commands."launch-konsole" = {
        name = "Launch Konsole";
        key = "Meta+Return";
        command = "konsole";
      };

      workspace.wallpaperSlideShow = wallpapers;
      kscreenlocker.appearance.wallpaperSlideShow = wallpapers;

      panels = [
        {
          location = "bottom";
          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.pager"
            {
              iconTasks = {
                iconsOnly = false;
                launchers = [
                  "applications:systemsettings.desktop"
                  "preferred://filemanager"
                  "preferred://browser"
                  "applications:org.kde.konsole.desktop"
                  "applications:org.kde.elisa.desktop"
                ];
              };
            }
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            { digitalClock.time.format = "24h"; }
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
    };

    elisa = {
      enable = true;
      indexer.paths = [ (syncDir + "music") ];
    };
  };
}

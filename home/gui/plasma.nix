{ config, ... }:
let
  syncDir = "${config.home.homeDirectory}/sync/a/";
  ubuntuFont = {
    family = "Ubuntu";
    pointSize = 10;
  };
  wallpapers = {
    path = syncDir + "images/wallpapers/desktop";
    interval = 3600;
  };
in
{
  programs = {
    plasma = {
      enable = true;
      overrideConfig = true;

      powerdevil = {
        AC.autoSuspend.action = "nothing";
        battery.autoSuspend.action = "nothing";
      };

      shortcuts = {
        "kitty.desktop"._launch = "Meta+Return";
        ksmserver."Log Out" = "Meta+Shift+E";
        kwin."Window Close" = "Meta+Q";
      };

      krunner = {
        position = "center";
        shortcuts.launch = "Meta";
        historyBehavior = "disabled";
      };

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

      kwin.nightLight = {
        enable = true;
        mode = "times";
        time = {
          evening = "18:00";
          morning = "06:00";
        };
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
                  "preferred://filemanager"
                  "preferred://browser"
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

      configFile = {
        baloofilerc."Basic Settings".Indexing-Enabled = false;
        kwinrc.Wayland.InputMethod = "org.fcitx.Fcitx5.desktop";
        krunnerrc.Plugins = {
          "org.kde.activities2Enabled" = false;
          "org.kde.datetimeEnabled" = false;
          baloosearchEnabled = false;
          browserhistoryEnabled = false;
          calculatorEnabled = false;
          helprunnerEnabled = false;
          krunner_appstreamEnabled = false;
          krunner_bookmarksrunnerEnabled = false;
          krunner_charrunnerEnabled = false;
          krunner_colorsEnabled = false;
          krunner_dictionaryEnabled = false;
          krunner_katesessionsEnabled = false;
          krunner_keysEnabled = false;
          krunner_killEnabled = false;
          krunner_konsoleprofilesEnabled = false;
          krunner_kwinEnabled = false;
          krunner_placesrunnerEnabled = false;
          krunner_plasma-desktopEnabled = false;
          krunner_powerdevilEnabled = false;
          krunner_recentdocumentsEnabled = false;
          krunner_sessionsEnabled = false;
          krunner_shellEnabled = false;
          krunner_spellcheckEnabled = false;
          krunner_systemsettingsEnabled = false;
          krunner_webshortcutsEnabled = false;
          locationsEnabled = false;
          unitconverterEnabled = false;
          windowsEnabled = false;
        };
      };
    };

    elisa = {
      enable = true;
      indexer.paths = [ (syncDir + "music") ];
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.myModules.gui;
  syncDir = "${config.home.homeDirectory}/sync/a/";
  ubuntuFont = {
    family = "Ubuntu";
    pointSize = 10;
  };
  wallpapers = {
    path = syncDir + "images/wallpapers/desktop";
    interval = 3600; # 1 hour
  };
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      elisa = {
        enable = true;
        indexer.paths = [ (syncDir + "music") ];
      };

      plasma = {
        enable = true;
        overrideConfig = true;

        powerdevil = {
          # disable auto-suspend to prevent interruptions
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
              {
                name = "org.kde.plasma.systemmonitor";
                config = {
                  Appearance = {
                    chartFace = "org.kde.ksysguard.textonly";
                    title = "Net Speed";
                  };
                  Sensors = {
                    highPrioritySensorIds = ''["network/all/upload","network/all/download"]'';
                    lowPrioritySensorIds = ''["cpu/all/usage","memory/physical/usedPercent"]'';
                  };
                  SensorLabels = {
                    "network/all/upload" = "△";
                    "network/all/download" = "▽";
                    "cpu/all/usage" = "CPU";
                    "memory/physical/usedPercent" = "RAM";
                  };
                  SensorColors = {
                    "network/all/upload" = "239,240,241";
                    "network/all/download" = "239,240,241";
                    "cpu/all/usage" = "239,240,241";
                    "memory/physical/usedPercent" = "239,240,241";
                  };
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
          baloofilerc."Basic Settings".Indexing-Enabled = false; # disable file indexing
          kwinrc.Wayland.InputMethod = "org.fcitx.Fcitx5.desktop";
          # only keep app launcher, disable all other plugins
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
    };
  };
}

{
  config,
  inputs,
  lib,
  user,
  ...
}:
let
  cfg = config.myModules.desktop;
  syncDir = builtins.replaceStrings [ "$HOME" ] [ config.home.homeDirectory ] user.syncDir;
  musicDir = "${syncDir}/music";

  font = {
    family = "Sans Serif";
    pointSize = 10;
  };

  wallpapers = {
    path = "${syncDir}/images/wallpapers/desktop";
    interval = 3600; # 1 hour
  };

  sysMonitorWidget =
    let
      up = "network/all/upload";
      down = "network/all/download";
      cpu = "cpu/all/usage";
      mem = "memory/physical/usedPercent";
      color = "239,240,241";
    in
    {
      name = "org.kde.plasma.systemmonitor";
      config = {
        Appearance = {
          chartFace = "org.kde.ksysguard.textonly";
          title = "Net Speed";
          updateRateLimit = 1000; # 1 second
        };
        Sensors = {
          highPrioritySensorIds = ''["${up}","${down}"]'';
          lowPrioritySensorIds = ''["${cpu}","${mem}"]'';
        };
        SensorLabels = {
          ${up} = "△";
          ${down} = "▽";
          ${cpu} = "CPU";
          ${mem} = "MEM";
        };
        SensorColors = lib.genAttrs [ up down cpu mem ] (_: color);
      };
    };

  disabledKRunnerPlugins = [
    "baloosearchEnabled"
    "browserhistoryEnabled"
    "helprunnerEnabled"
    "krunner_appstreamEnabled"
    "krunner_bookmarksrunnerEnabled"
    "krunner_charrunnerEnabled"
    "krunner_dictionaryEnabled"
    "krunner_katesessionsEnabled"
    "krunner_keysEnabled"
    "krunner_konsoleprofilesEnabled"
    "krunner_kwinEnabled"
    "krunner_placesrunnerEnabled"
    "krunner_plasma-desktopEnabled"
    "krunner_powerdevilEnabled"
    "krunner_recentdocumentsEnabled"
    "krunner_sessionsEnabled"
    "krunner_shellEnabled"
    "krunner_spellcheckEnabled"
    "krunner_systemsettingsEnabled"
    "krunner_webshortcutsEnabled"
    "locationsEnabled"
    "org.kde.activities2Enabled"
    "org.kde.datetimeEnabled"
    "windowsEnabled"
  ];
in
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  config = lib.mkIf cfg.enable {
    programs = {
      elisa = {
        enable = true;
        indexer.paths = [ musicDir ];
      };

      plasma = {
        enable = true;
        # overrideConfig = true;

        fonts = {
          general = font;
          fixedWidth = font // {
            family = "Monospace";
          };
          small = font // {
            pointSize = 8;
          };
          toolbar = font;
          menu = font;
          windowTitle = font;
        };

        input.keyboard = {
          repeatDelay = 250;
          repeatRate = 30;
        };

        krunner.historyBehavior = "disabled";

        workspace.wallpaperSlideShow = wallpapers;
        kscreenlocker = {
          appearance.wallpaperSlideShow = wallpapers;
          passwordRequiredDelay = 0;
        };

        kwin.nightLight = {
          enable = true;
          mode = "times";
          time = {
            evening = "18:00";
            morning = "06:00";
          };
        };

        panels = [
          {
            location = "bottom";
            widgets = [
              { kickoff.settings.General.highlightNewlyInstalledApps = false; }
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
              sysMonitorWidget
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              { digitalClock.time.format = "24h"; }
              "org.kde.plasma.showdesktop"
            ];
          }
        ];

        powerdevil = {
          AC = {
            autoSuspend.action = "nothing";
            dimDisplay.idleTimeout = 270;
            turnOffDisplay.idleTimeout = 300;
          };
          battery.turnOffDisplay.idleTimeout = 150;
          lowBattery.turnOffDisplay.idleTimeout = 90;
        };

        shortcuts = {
          "kitty.desktop"._launch = "Meta+Return";
          ksmserver."Log Out" = "Meta+Shift+E";
          kwin."Window Close" = "Meta+Q";
        };

        configFile = {
          baloofilerc."Basic Settings".Indexing-Enabled = false;
          krunnerrc.Plugins = lib.genAttrs disabledKRunnerPlugins (_: false);
          kwinrc = {
            Effect-overview.BorderActivate = 9; # disable top-left overview trigger
            # prevent fcitx5 warning about missing virtual keyboard
            Wayland.InputMethod = "org.fcitx.Fcitx5.desktop";
          };
        };
      };
    };
  };
}

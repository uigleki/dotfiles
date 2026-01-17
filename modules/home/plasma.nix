{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.myModules.desktop;
  syncDir = "${config.home.homeDirectory}/sync/a/";
  musicDir = "${syncDir}music";

  font = {
    family = "Ubuntu";
    pointSize = 10;
  };

  wallpapers = {
    path = "${syncDir}images/wallpapers/desktop";
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
        overrideConfig = true;

        fonts = {
          general = font;
          fixedWidth = font // {
            family = "Ubuntu Mono";
          };
          small = font // {
            pointSize = 8;
          };
          toolbar = font;
          menu = font;
          windowTitle = font;
        };

        kscreenlocker.appearance.wallpaperSlideShow = wallpapers;
        workspace.wallpaperSlideShow = wallpapers;

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

        powerdevil.AC.autoSuspend.action = "nothing";

        input.keyboard = {
          repeatDelay = 250;
          repeatRate = 30;
        };

        shortcuts = {
          "kitty.desktop"._launch = "Meta+Return";
          ksmserver."Log Out" = "Meta+Shift+E";
          kwin."Window Close" = "Meta+Q";
        };

        krunner.historyBehavior = "disabled";

        configFile = {
          baloofilerc."Basic Settings".Indexing-Enabled = false;
          krunnerrc.Plugins = lib.genAttrs disabledKRunnerPlugins (_: false);
          # prevent fcitx5 warning about missing virtual keyboard
          kwinrc.Wayland.InputMethod = "org.fcitx.Fcitx5.desktop";
        };
      };
    };
  };
}

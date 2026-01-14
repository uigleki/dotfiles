{ config, lib, ... }:
let
  cfg = config.myModules.gui;
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
      ram = "memory/physical/usedPercent";
      color = "239,240,241";
      sensors = [
        up
        down
        cpu
        ram
      ];
    in
    {
      name = "org.kde.plasma.systemmonitor";
      config = {
        Appearance = {
          chartFace = "org.kde.ksysguard.textonly";
          title = "Net Speed";
        };
        Sensors = {
          highPrioritySensorIds = builtins.toJSON [
            up
            down
          ];
          lowPrioritySensorIds = builtins.toJSON [
            cpu
            ram
          ];
        };
        SensorLabels = {
          ${up} = "△";
          ${down} = "▽";
          ${cpu} = "CPU";
          ${ram} = "RAM";
        };
        SensorColors = lib.genAttrs sensors (_: color);
      };
    };

  disabledKRunnerPlugins = [
    "org.kde.activities2Enabled"
    "org.kde.datetimeEnabled"
    "baloosearchEnabled"
    "browserhistoryEnabled"
    "calculatorEnabled"
    "helprunnerEnabled"
    "krunner_appstreamEnabled"
    "krunner_bookmarksrunnerEnabled"
    "krunner_charrunnerEnabled"
    "krunner_colorsEnabled"
    "krunner_dictionaryEnabled"
    "krunner_katesessionsEnabled"
    "krunner_keysEnabled"
    "krunner_killEnabled"
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
    "unitconverterEnabled"
    "windowsEnabled"
  ];
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      elisa = {
        enable = true;
        indexer.paths = [ musicDir ];
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
              sysMonitorWidget
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              { digitalClock.time.format = "24h"; }
              "org.kde.plasma.showdesktop"
            ];
          }
        ];

        configFile = {
          baloofilerc."Basic Settings".Indexing-Enabled = false;
          krunnerrc.Plugins = lib.genAttrs disabledKRunnerPlugins (_: false);
          kwinrc.Wayland.InputMethod = "org.fcitx.Fcitx5.desktop";
        };
      };
    };
  };
}

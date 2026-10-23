{ config, inputs, ... }:
let
  inherit (config) owner;
in
{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        environment = {
          plasma6.excludePackages = with pkgs.kdePackages; [
            baloo-widgets
            discover
            khelpcenter
            konsole
            krdp
            plasma-browser-integration
            plasma-workspace-wallpapers
          ];

          # required by ark for 7z and rar
          systemPackages = with pkgs; [
            _7zz
            unar
          ];
        };

        programs.kdeconnect.enable = true;

        services = {
          desktopManager.plasma6.enable = true;
          displayManager.sddm.enable = true;
        };
      };

    homeManager.desktop =
      { config, lib, ... }:
      let
        syncDir = "${config.home.homeDirectory}/${owner.syncDir}";

        font = {
          family = "Sans Serif";
          pointSize = 10;
        };

        wallpapers = {
          path = "${syncDir}/images/wallpapers/desktop";
          interval = 3600; # 1 hour in seconds
        };

        sysMonitorWidget =
          let
            # sensors in display order
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
                updateRateLimit = 1000; # 1 second in ms
              };

              SensorColors = lib.genAttrs [ up down cpu mem ] (_: color);

              SensorLabels = {
                ${up} = "△";
                ${down} = "▽";
                ${cpu} = "CPU";
                ${mem} = "MEM";
              };

              Sensors = {
                highPrioritySensorIds = ''["${up}","${down}"]'';
                lowPrioritySensorIds = ''["${cpu}","${mem}"]'';
              };
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

        programs = {
          elisa = {
            enable = true;
            indexer.paths = [ "${syncDir}/music" ];
          };

          plasma = {
            enable = true;
            # overrideConfig = true; # uncomment to purge unmanaged KDE settings; slows startup

            configFile = {
              baloofilerc."Basic Settings".Indexing-Enabled = false;
              kdeglobals.KDE.CursorBlinkRate = 0;
              knighttimerc.General.Source = "Times";
              krunnerrc.Plugins = lib.genAttrs disabledKRunnerPlugins (_: false);
              kwinrc.Effect-overview.BorderActivate = 9; # disable top-left overview trigger
              plasmanotifyrc."Applications/@other".ShowInHistory = true;
            };

            fonts = lib.genAttrs [ "general" "menu" "toolbar" "windowTitle" ] (_: font) // {
              fixedWidth = font // {
                family = "Monospace";
              };

              small = font // {
                pointSize = 8;
              };
            };

            input.keyboard = {
              repeatDelay = 250;
              repeatRate = 30;
            };

            krunner.historyBehavior = "disabled";

            kscreenlocker = {
              appearance.wallpaperSlideShow = wallpapers;
              passwordRequiredDelay = 0;
            };

            kwin.nightLight.enable = true;

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
                        "applications:dev.zed.Zed.desktop"
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
              ksmserver."Log Out" = "Meta+Shift+E";
              kwin."Window Close" = "Meta+Q";
              "services/kitty.desktop"._launch = "Meta+Return";
            };

            workspace.wallpaperSlideShow = wallpapers;
          };
        };
      };
  };
}

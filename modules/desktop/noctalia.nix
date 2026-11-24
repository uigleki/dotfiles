{ config, ... }:
let
  inherit (config) user;
in
{
  nixos.modules.desktop = {
    environment.persistence = {
      "/cache".directories = [ "/var/lib/upower" ]; # battery history, rewritten whole on every save
      "/persist".directories = [ "/var/lib/power-profiles-daemon" ];
    };

    # the battery and power profile widgets read these
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };

  homeManager.modules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      package = pkgs.unstable.noctalia; # TODO: on 26.11, use stable
      barPosition = "bottom";

      configFile = (pkgs.formats.toml { }).generate "noctalia-config.toml" {
        bar.default = {
          margin_ends = 0;
          position = barPosition;
          radius = 0;

          start = [
            "launcher"
            "workspaces"
            "taskbar"
          ];

          center = [ ];

          end = [
            "media"
            "privacy"
            "network_tx"
            "network_rx"
            "cpu"
            "ram"
            "disk"
            "tray"
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "clock"
            "control-center"
            "session"
          ];
        };

        idle = {
          behavior = {
            lock = {
              action = "lock";
              timeout = 270;
            };

            screen-off = {
              action = "screen_off";
              locked_timeout = 5; # the fade still runs, hidden behind the lock screen
              timeout = 270;
            };
          };

          behavior_order = [
            # the lock screen flashes before the display goes dark when lock runs first
            "screen-off"
            "lock"
          ];

          pre_action_fade_seconds = 30;
        };

        lockscreen = {
          blur_intensity = 0;
          tint_intensity = 0;
        };

        # noctalia saves this section into its state settings.toml, which overrides edits here until deleted
        lockscreen_widgets = {
          enabled = true;

          widget =
            let
              width = 1920;

              clock = {
                cx = width / 2;
                # cx and cy scale from this size to the actual output
                placement_width = width;
                placement_height = 1080;
                # clocks have no font size; the content is scaled to fit this box
                box_width = 800;

                settings = {
                  background = false;
                  color = "#ffffff";
                };
              };
            in
            lib.mapAttrs (_: lib.recursiveUpdate clock) {
              time = {
                cy = 330;
                box_height = 200;
              };

              date = {
                cy = 460;
                box_height = 40;
                settings.format = "{:%A, %B %d}";
              };
            };
        };

        location = {
          custom_schedule = true;
          sunrise = "06:00";
          sunset = "18:00";
        };

        nightlight = {
          enabled = true;
          temperature_night = 4500;
        };

        notification.position = "${barPosition}_right";
        osd.position = "${barPosition}_center";

        shell = {
          greeter_sync.auto_sync = true;
          offline_mode = true;

          panel = lib.mergeAttrsList (
            map
              (name: {
                "${name}_placement" = "floating";
                "open_near_click_${name}" = true;
              })
              [
                "control_center"
                "session"
                "wallpaper"
              ]
          );

          polkit_agent = true;
          readline_shortcuts = true;
          setup_wizard_enabled = false;
        };

        theme = {
          builtin = "Catppuccin";
          mode = "light";

          templates.builtin_ids = [
            "gtk3"
            "gtk4"
            "niri"
            "qt"
          ];
        };

        wallpaper = {
          automation = {
            enabled = true;
            interval_seconds = 3600;
            recursive = true;
          };

          directory = "${config.home.homeDirectory}/${user.syncDir}/images/wallpapers/desktop";
          transition_on_startup = true;
        };

        weather.enabled = false; # its card only shows "No location set"

        widget = {
          battery.hide_when_full = true;
          brightness.show_label = false;
          clock.tooltip_format = "{:%Y-%m-%d %A}";

          disk = {
            type = "sysmon";
            stat = "disk_free";
          };

          media.hide_when_no_media = true;
          network.show_label = false;
          network_rx.network_speed_compact = true;
          network_tx.network_speed_compact = true;
          privacy.hide_inactive = true;
          taskbar.show_window_title = true;
        };
      };
    in
    {
      home = {
        packages = [
          package
          pkgs.adw-gtk3 # the gtk templates select this theme
        ];

        persistence."/persist".directories = [ ".local/state/noctalia" ]; # settings, clipboard and notification history
      };

      # the qt template only writes the palette; qt6ct has to be pointed at it
      qt.qt6ctSettings.Appearance = {
        color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
        custom_palette = true;
        style = "Fusion";
      };

      # TODO: on 26.11, use the native module
      xdg.configFile."noctalia/config.toml".source =
        pkgs.runCommand "noctalia-config.toml" { nativeBuildInputs = [ package ]; }
          ''
            noctalia config validate ${configFile}
            cp ${configFile} $out
          '';
    };
}

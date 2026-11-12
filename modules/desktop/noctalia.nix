{ config, ... }:
let
  inherit (config) owner;
in
{
  flake.modules = {
    nixos.desktop = {
      qt = {
        enable = true;
        platformTheme = "qt5ct"; # qt6ct answers to this name too
      };

      # the battery and power profile widgets read these
      services = {
        power-profiles-daemon.enable = true;
        upower.enable = true;
      };
    };

    homeManager.desktop =
      { config, pkgs, ... }:
      let
        package = pkgs.unstable.noctalia;

        configFile = (pkgs.formats.toml { }).generate "noctalia-config.toml" {
          bar.default = {
            margin_ends = 0;
            position = "bottom";
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

          location = {
            auto_locate = true;
            custom_schedule = true;
            sunrise = "06:00";
            sunset = "18:00";
          };

          nightlight = {
            enabled = true;
            temperature_night = 4500;
          };

          shell = {
            greeter_sync.auto_sync = true;
            polkit_agent = true;
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
            directory = "${config.home.homeDirectory}/${owner.syncDir}/images/wallpapers/desktop";

            automation = {
              enabled = true;
              interval_seconds = 3600;
              recursive = true;
            };
          };

          widget = {
            battery.hide_when_full = true;
            brightness.show_label = false;
            clock.tooltip_format = "{:%Y-%m-%d %A}";
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
        home.packages = [
          package
          pkgs.adw-gtk3 # the gtk templates select this theme
        ];

        qt = {
          enable = true;

          # the qt template only writes the palette; qt6ct has to be pointed at it
          qt6ctSettings.Appearance = {
            color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
            custom_palette = true;
            style = "Fusion";
          };
        };

        # home-manager master has programs.noctalia, which replaces this file and its validation once a release ships it
        xdg.configFile."noctalia/config.toml".source =
          pkgs.runCommand "noctalia-config.toml" { nativeBuildInputs = [ package ]; }
            ''
              noctalia config validate ${configFile}
              cp ${configFile} $out
            '';
      };
  };
}

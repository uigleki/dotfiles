{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.theme;
  theme = "Catppuccin Latte";
in
{
  options.myModules.theme.enable = lib.mkEnableOption "Enable theme configuration." // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "eza/theme.yml".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/eza-community/eza-themes/562fb6d/themes/catppuccin-latte.yml";
        sha256 = "sha256-sSf7wrJTwnt/zO+dsOF13KDsoIOtKAHyF/g3I5OcRCw=";
      };

      "fish/themes/Catppuccin Latte.theme".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/fish/af622a6/themes/Catppuccin%20Latte.theme";
        sha256 = "sha256-GHxIQkF2Co4vZpkPzz54PGnsrfYvzzl8MF+ak3lUpzA=";
      };

      "yazi/theme.toml".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/yazi-rs/flavors/ffe6e3a/catppuccin-latte.yazi/flavor.toml";
        sha256 = "sha256-JLZpOm0WEQ1xbEhmJYe4SBFNaPx0Jp5l6Wy/3rGk40c=";
      };
    };

    programs = {
      bat.config.theme = theme; # bat --list-themes
      delta.options.syntax-theme = theme; # same as bat
      helix.settings.theme = "catppuccin_latte"; # :theme
      kitty.themeFile = "Catppuccin-Latte"; # https://github.com/kovidgoyal/kitty-themes/tree/master/themes

      fish.interactiveShellInit = ''fish_config theme choose "Catppuccin Latte"'';

      bottom.settings = lib.importTOML (
        builtins.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/bottom/eadd75a/themes/latte.toml";
          sha256 = "0gyvvg3l3fzd745i0k0d95fcx74djx3czh6m2kddp2gfb2hhnigv";
        }
      );

      starship.settings = {
        palette = "catppuccin_latte";
      }
      // lib.importTOML (
        builtins.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/starship/0cf9141/themes/latte.toml";
          sha256 = "172k2d2m7xcgp8xkgvjyvyfnksq5812crsfg3bxly22xmg0qmjzp";
        }
      );

      tmux = {
        plugins = [ pkgs.tmuxPlugins.catppuccin ];
        extraConfig = ''set -g @catppuccin_flavor "latte"'';
      };

      fzf.defaultOptions = [
        # https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-latte.sh
        "--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39"
        "--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78"
        "--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39"
        "--color=selected-bg:#BCC0CC"
        "--color=border:#9CA0B0,label:#4C4F69"
      ];

      lazygit.settings.gui = {
        # https://github.com/catppuccin/lazygit/blob/main/themes/latte/mauve.yml
        theme = {
          activeBorderColor = [
            "#8839ef"
            "bold"
          ];
          inactiveBorderColor = [ "#6c6f85" ];
          optionsTextColor = [ "#1e66f5" ];
          selectedLineBgColor = [ "#ccd0da" ];
          cherryPickedCommitBgColor = [ "#bcc0cc" ];
          cherryPickedCommitFgColor = [ "#8839ef" ];
          unstagedChangesColor = [ "#d20f39" ];
          defaultFgColor = [ "#4c4f69" ];
          searchingActiveBorderColor = [ "#df8e1d" ];
        };
        authorColors."*" = "#7287fd";
      };

      mpv = {
        # https://github.com/catppuccin/mpv/blob/main/themes/latte/mauve.conf
        config = {
          background-color = "#eff1f5";
          osd-back-color = "#dce0e8";
          osd-border-color = "#dce0e8";
          osd-color = "#4c4f69";
          osd-shadow-color = "#eff1f5";
        };
        scriptOpts = {
          stats = {
            border_color = "efe9e6";
            font_color = "694f4c";
            plot_bg_border_color = "ef3988";
            plot_bg_color = "efe9e6";
            plot_color = "ef3988";
          };
          uosc = {
            color = "foreground=8839ef,foreground_text=ccd0da,background=eff1f5,background_text=4c4f69,curtain=e6e9ef,success=40a02b,error=d20f39";
          };
        };
      };
    };
  };
}

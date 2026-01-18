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
  options.myModules.theme.enable = lib.mkEnableOption "color theme" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.LG_CONFIG_FILE = lib.concatStringsSep "," [
      "${config.xdg.configHome}/lazygit/config.yml"
      (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/lazygit/21a25af/themes-mergable/latte/mauve.yml";
        sha256 = "0yjqn59l9kmhzklkbkqy5l4g5pbwyrilpcrmmvha8bgvks4vsxbz";
      })
    ];

    programs = {
      bat.config.theme = theme; # bat --list-themes
      delta.options.syntax-theme = theme; # same as bat
      fish.interactiveShellInit = ''fish_config theme choose "Catppuccin Latte"'';
      helix.settings.theme = "catppuccin_latte"; # :theme
      kitty.themeFile = "Catppuccin-Latte"; # https://github.com/kovidgoyal/kitty-themes/tree/master/themes

      bottom.settings = lib.importTOML (
        builtins.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/bottom/eadd75a/themes/latte.toml";
          sha256 = "0gyvvg3l3fzd745i0k0d95fcx74djx3czh6m2kddp2gfb2hhnigv";
        }
      );

      fzf.defaultOptions = [
        # https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-latte.sh
        "--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39"
        "--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78"
        "--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39"
        "--color=selected-bg:#BCC0CC"
        "--color=border:#9CA0B0,label:#4C4F69"
      ];

      mpv.config.include = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/mpv/7cb9402/themes/latte/mauve.conf";
        sha256 = "0bjy7phjxn53qz4f3s47798nlvagrbgfy5c075lldy7439sqwiyn";
      };

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
    };

    xdg.configFile = {
      "eza/theme.yml".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/eza-community/eza-themes/562fb6d/themes/catppuccin-latte.yml";
        sha256 = "sSf7wrJTwnt/zO+dsOF13KDsoIOtKAHyF/g3I5OcRCw=";
      };

      "fish/themes/Catppuccin Latte.theme".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/fish/af622a6/themes/Catppuccin%20Latte.theme";
        sha256 = "GHxIQkF2Co4vZpkPzz54PGnsrfYvzzl8MF+ak3lUpzA=";
      };

      "yazi/theme.toml".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/yazi-rs/flavors/ffe6e3a/catppuccin-latte.yazi/flavor.toml";
        sha256 = "JLZpOm0WEQ1xbEhmJYe4SBFNaPx0Jp5l6Wy/3rGk40c=";
      };
    };
  };
}

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
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/lazygit/21a25af/themes-mergable/latte/mauve.yml";
        hash = "sha256-f3W9iZ77LaTgrjWzS2P2fN3yCC0ezzXp/LDORFOxWHo=";
      })
    ];

    programs = {
      bat.config.theme = theme; # bat --list-themes
      delta.options.syntax-theme = theme; # same as bat
      # every catppuccin theme bundled with fish uses Latte for light mode
      fish.interactiveShellInit = "fish_config theme choose catppuccin-mocha --color-theme=light";
      helix.settings.theme = "catppuccin_latte"; # :theme
      kitty.themeFile = "Catppuccin-Latte"; # https://github.com/kovidgoyal/kitty-themes/tree/master/themes

      # importTOML reads the file at eval time, so it needs builtins.fetchurl
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

      mpv.config.include = toString (
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/mpv/7cb9402/themes/latte/mauve.conf";
          hash = "sha256-1keOdRrk+EZpOYAV797KT21qUTqH6OHIx6PYLuE9Xi4=";
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
    };

    xdg.configFile = {
      "eza/theme.yml".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/eza-community/eza-themes/562fb6d/themes/catppuccin-latte.yml";
        hash = "sha256-sSf7wrJTwnt/zO+dsOF13KDsoIOtKAHyF/g3I5OcRCw=";
      };

      "yazi/theme.toml".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/yazi-rs/flavors/c02c804/catppuccin-latte.yazi/flavor.toml";
        hash = "sha256-31XnC09PKXJgvgt3zz1lMwhr0Fg+dzjc68IjJ/z6tSA=";
      };
    };
  };
}

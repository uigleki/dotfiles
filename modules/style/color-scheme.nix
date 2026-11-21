{ inputs, ... }:
{
  homeManager.modules.base =
    { config, lib, ... }:
    let
      theme = "Catppuccin Latte";
    in
    {
      home.sessionVariables.LG_CONFIG_FILE = lib.concatStringsSep "," [
        "${config.xdg.configHome}/lazygit/config.yml"
        "${inputs.catppuccin-lazygit}/themes-mergable/latte/mauve.yml"
      ];

      programs = {
        bat.config.theme = theme; # bat --list-themes
        bottom.settings = lib.importTOML "${inputs.catppuccin-bottom}/themes/latte.toml";
        delta.options.syntax-theme = theme; # same as bat
        # every catppuccin theme bundled with fish uses Latte for light mode
        fish.interactiveShellInit = "fish_config theme choose catppuccin-mocha --color-theme=light";

        # https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-latte.sh
        fzf.colors = {
          bg = "#EFF1F5";
          "bg+" = "#CCD0DA";
          border = "#9CA0B0";
          fg = "#4C4F69";
          "fg+" = "#4C4F69";
          header = "#D20F39";
          hl = "#D20F39";
          "hl+" = "#D20F39";
          info = "#8839EF";
          label = "#4C4F69";
          marker = "#7287FD";
          pointer = "#DC8A78";
          prompt = "#8839EF";
          selected-bg = "#BCC0CC";
          spinner = "#DC8A78";
        };

        helix.settings.theme = "catppuccin_latte"; # :theme
        kitty.themeFile = "Catppuccin-Latte"; # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
        mpv.config.include = "${inputs.catppuccin-mpv}/themes/latte/mauve.conf";

        starship.settings = {
          palette = "catppuccin_latte";
        }
        // lib.importTOML "${inputs.catppuccin-starship}/themes/latte.toml";

        yazi = {
          flavors.catppuccin-latte = "${inputs.yazi-flavors}/catppuccin-latte.yazi";

          theme.flavor = {
            dark = "catppuccin-latte";
            light = "catppuccin-latte";
          };
        };

        zed-editor = {
          extensions = [
            "catppuccin"
            "catppuccin-icons"
          ];

          userSettings = {
            icon_theme = {
              light = theme;
              dark = "Catppuccin Macchiato";
            };

            theme = {
              light = theme;
              dark = "Catppuccin Macchiato";
            };
          };
        };
      };

      xdg.configFile."eza/theme.yml".source = "${inputs.eza-themes}/themes/catppuccin-latte.yml";
    };
}

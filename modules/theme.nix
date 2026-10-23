{ inputs, ... }:
{
  flake.modules.homeManager.base =
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
        helix.settings.theme = "catppuccin_latte"; # :theme
        kitty.themeFile = "Catppuccin-Latte"; # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
        mpv.config.include = "${inputs.catppuccin-mpv}/themes/latte/mauve.conf";

        fzf.defaultOptions = [
          # https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-latte.sh
          "--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39"
          "--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78"
          "--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39"
          "--color=selected-bg:#BCC0CC"
          "--color=border:#9CA0B0,label:#4C4F69"
        ];

        starship.settings = {
          palette = "catppuccin_latte";
        }
        // lib.importTOML "${inputs.catppuccin-starship}/themes/latte.toml";

        yazi = {
          flavors.catppuccin-latte = "${inputs.yazi-flavors}/catppuccin-latte.yazi";
          theme.flavor = {
            light = "catppuccin-latte";
            dark = "catppuccin-latte";
          };
        };
      };

      xdg.configFile = {
        "eza/theme.yml".source = "${inputs.eza-themes}/themes/catppuccin-latte.yml";
      };
    };
}

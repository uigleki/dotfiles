let
  theme = "Solarized (light)";
in
{
  programs = {
    bat.config.theme = theme;
    bottom.settings.flags.color = "gruvbox-light";
    delta.options.syntax-theme = theme;
    helix.settings.theme = "solarized_light";
    kitty.themeFile = "Solarized_Light";
  };
}

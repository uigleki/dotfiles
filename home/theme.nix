let
  theme = "gruvbox-light";
in
{
  programs = {
    bat.config.theme = theme;
    bottom.settings.flags.color = theme;
    git.delta.options.syntax-theme = theme;
    helix.settings.theme = "gruvbox_light";
  };
}

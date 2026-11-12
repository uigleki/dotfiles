{
  nixos.modules.desktop =
    { pkgs, ... }:
    {
      # GTK programs that nixpkgs does not wrap cannot load SVG icons without it
      programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    };

  homeManager.modules.desktop =
    { pkgs, ... }:
    let
      theme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    in
    {
      gtk.iconTheme = theme;

      qt.qt6ctSettings.Appearance.icon_theme = theme.name;
    };
}

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
      gtk = {
        enable = true;
        iconTheme = theme;
      };

      home.pointerCursor = {
        inherit (theme) name package;
        gtk.enable = true;
        size = 24;
      };

      qt.qt6ctSettings.Appearance.icon_theme = theme.name;
    };
}

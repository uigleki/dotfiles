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
        name = "Papirus-Light";
        package = pkgs.papirus-icon-theme;
      };
    in
    {
      gtk.iconTheme = theme;

      qt.qt6ctSettings.Appearance.icon_theme = theme.name;

      # Flatpak apps see the user's icons but not the home-manager profile
      xdg.dataFile."icons/${theme.name}".source = "${theme.package}/share/icons/${theme.name}";
    };
}

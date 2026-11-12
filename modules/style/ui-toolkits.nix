{
  nixos.modules.desktop.qt = {
    enable = true;
    platformTheme = "qt5ct"; # qt6ct answers to this name too
  };

  homeManager.modules.desktop = {
    gtk.enable = true;
    qt.enable = true;
  };
}

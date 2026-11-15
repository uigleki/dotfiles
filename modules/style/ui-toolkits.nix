{
  nixos.modules.desktop.qt = {
    enable = true;
    platformTheme = "qt5ct"; # qt6ct answers to this name too
  };

  homeManager.modules.desktop = {
    gtk.enable = true;

    home.persistence."/persist" = {
      directories = [ ".config/gtk-3.0" ]; # file manager bookmarks

      # file dialog history; Qt replaces it by rename, which a bind-mounted file refuses
      files = [
        {
          file = ".config/QtProject.conf";
          method = "symlink";
        }
      ];
    };

    qt.enable = true;
  };
}

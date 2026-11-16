{
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

    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };
  };
}

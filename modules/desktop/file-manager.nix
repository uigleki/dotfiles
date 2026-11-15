{
  nixos.modules.desktop.services.gvfs.enable = true; # trash, removable drives and phones in Nautilus

  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          ffmpegthumbnailer # Nautilus thumbnails videos with it
          nautilus
        ];

        persistence = {
          "/persist".directories = [
            ".local/share/gvfs-metadata" # per-file metadata, e.g. custom icons
            ".local/share/nautilus" # starred files and scripts
          ];
          "/cache".directories = [ ".local/share/Trash" ]; # can grow large, and is already thrown away
        };
      };

      xdg.mimeApps.defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";
    };
}

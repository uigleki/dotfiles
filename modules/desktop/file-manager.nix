{
  nixos.modules.desktop.services.gvfs.enable = true; # trash, removable drives and phones in Nautilus

  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ffmpegthumbnailer # Nautilus thumbnails videos with it
        nautilus
      ];

      xdg.mimeApps.defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";
    };
}

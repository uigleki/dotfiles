{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.papers ];
      xdg.mimeApps.defaultApplications."application/pdf" = "org.gnome.Papers.desktop";
    };
}

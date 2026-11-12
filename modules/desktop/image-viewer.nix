{
  homeManager.modules.desktop =
    { lib, pkgs, ... }:
    {
      home.packages = [ pkgs.loupe ];

      xdg.mimeApps.defaultApplications = lib.genAttrs [
        "image/avif"
        "image/bmp"
        "image/gif"
        "image/heic"
        "image/jpeg"
        "image/jxl"
        "image/png"
        "image/svg+xml"
        "image/tiff"
        "image/webp"
      ] (_: "org.gnome.Loupe.desktop");
    };
}

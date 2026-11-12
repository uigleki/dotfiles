{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        gtk.enable = true;
        size = 24;
      };
    };
}

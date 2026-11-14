{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        gtk.enable = true;
        size = 24;
      };
    };
}

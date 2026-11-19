{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.loupe ];
      xdg.mimeApps.defaultApplicationPackages = [ pkgs.loupe ];
    };
}

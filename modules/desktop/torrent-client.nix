{
  homeManager.modules.desktop =
    { lib, pkgs, ... }:
    {
      home.packages = [ pkgs.qbittorrent-enhanced ];

      xdg.mimeApps.defaultApplications = lib.genAttrs [
        "application/x-bittorrent"
        "x-scheme-handler/magnet"
      ] (_: "org.qbittorrent.qBittorrent.desktop");
    };
}

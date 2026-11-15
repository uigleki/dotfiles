{
  homeManager.modules.desktop =
    { lib, pkgs, ... }:
    {
      home = {
        packages = [ pkgs.qbittorrent-enhanced ];

        persistence."/persist".directories = [
          ".config/qBittorrent"
          ".local/share/qBittorrent" # torrents and their resume data
        ];
      };

      xdg.mimeApps.defaultApplications = lib.genAttrs [
        "application/x-bittorrent"
        "x-scheme-handler/magnet"
      ] (_: "org.qbittorrent.qBittorrent.desktop");
    };
}

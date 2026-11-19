{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home = {
        packages = [ pkgs.qbittorrent-enhanced ];

        persistence."/persist".directories = [
          ".config/qBittorrent"
          ".local/share/qBittorrent" # torrents and their resume data
        ];
      };

      xdg.mimeApps.defaultApplicationPackages = [ pkgs.qbittorrent-enhanced ];
    };
}

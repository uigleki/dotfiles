{
  # home-manager shares the system pkgs, so its unfree packages are allowed there
  flake.modules.nixos.desktop.nixpkgs.config.allowUnfreePackages = [ "google-chrome" ];

  flake.modules.homeManager.desktop =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        cryptomator
        freefilesync
        motrix
        qbittorrent-enhanced
      ];

      programs = {
        google-chrome.enable = true;
        onlyoffice.enable = true;

        firefox = {
          enable = true;
          profiles.default = { }; # pin profile name
        };
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications =
          lib.genAttrs [
            "text/html"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ] (_: "firefox.desktop")
          // lib.genAttrs [
            "application/x-bittorrent"
            "x-scheme-handler/magnet"
          ] (_: "org.qbittorrent.qBittorrent.desktop");
      };
    };
}

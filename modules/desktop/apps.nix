{ config, ... }:
let
  inherit (config) owner;
in
{
  # home-manager shares the system pkgs, so its unfree packages are allowed there
  nixos.modules.desktop = {
    nixpkgs.config.allowUnfreePackages = [ "google-chrome" ];
    services.gvfs.enable = true; # trash, removable drives and phones in Nautilus
  };

  homeManager.modules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      dconf.settings."com/github/neithern/g4music".music-dir =
        "file://${config.home.homeDirectory}/${owner.syncDir}/music";

      home.packages = with pkgs; [
        _7zz # file-roller extracts encrypted 7z and zip with it
        cryptomator
        ffmpegthumbnailer # Nautilus thumbnails videos with it
        file-roller
        freefilesync
        gapless
        loupe
        motrix
        nautilus
        papers
        qbittorrent-enhanced
        unar # file-roller extracts encrypted rar with it
      ];

      programs = {
        firefox = {
          enable = true;
          profiles.default = { }; # pin profile name
        };

        google-chrome.enable = true;
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
          ] (_: "org.gnome.Loupe.desktop")
          // lib.genAttrs [
            "application/x-bittorrent"
            "x-scheme-handler/magnet"
          ] (_: "org.qbittorrent.qBittorrent.desktop")
          // {
            "application/pdf" = "org.gnome.Papers.desktop";
            "inode/directory" = "org.gnome.Nautilus.desktop";
            "text/plain" = "dev.zed.Zed.desktop";
          };
      };
    };
}

{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  cfg = config.myModules.desktop;
in
{
  imports = [
    ./kitty.nix
    ./mpv.nix
    ./plasma.nix
  ];

  options.myModules.desktop.enable = lib.mkEnableOption "desktop applications" // {
    default = osConfig.myModules.desktop.enable or false;
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cryptomator
      freefilesync
      motrix
      qbittorrent-enhanced
    ];

    programs = {
      onlyoffice.enable = true;

      chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };

      firefox = {
        enable = true;
        profiles.default = { }; # pin profile name
      };
    };

    services = {
      syncthing.tray.enable = true;
      tailscale-systray.enable = true;
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

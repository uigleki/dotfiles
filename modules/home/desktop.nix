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

      kitty = {
        enable = true;
        settings.cursor_blink_interval = 0;
      };
    };

    services = {
      syncthing.tray.enable = true;
      tailscale-systray.enable = true;
    };
  };
}

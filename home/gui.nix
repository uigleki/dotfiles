{
  config,
  osConfig ? null,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.gui;
in
{
  imports = [
    ./gui/mpv.nix
    ./gui/plasma.nix
  ];

  options.myModules.gui.enable = lib.mkEnableOption "Enable GUI configuration." // {
    default = osConfig.myModules.gui.enable or false;
  };

  config = lib.mkIf cfg.enable {
    myModules.dev.enable = true;

    home.packages = with pkgs; [
      cryptomator
      freefilesync
      motrix
      qbittorrent-enhanced
      unstable.antigravity
    ];

    programs = {
      onlyoffice.enable = true;
      vscode.enable = true;

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

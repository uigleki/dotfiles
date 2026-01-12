{
  osConfig ? null,
  lib,
  pkgs,
  ...
}:
let
  cfg = osConfig.myModules.gui or { enable = false; };
in
{
  imports = lib.optionals cfg.enable [
    ./gui/mpv.nix
    ./gui/plasma.nix
  ];

  config = lib.mkIf cfg.enable {
    myModules.dev.enable = true;

    home.packages = with pkgs; [
      cryptomator
      freefilesync
      google-chrome
      motrix
      qbittorrent-enhanced
      unstable.antigravity
    ];

    programs = {
      firefox.enable = true;
      onlyoffice.enable = true;
      vscode.enable = true;

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

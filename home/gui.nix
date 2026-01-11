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
      bottles
      cryptomator
      freefilesync
      google-chrome
      heroic
      motrix
      qbittorrent-enhanced
      unstable.antigravity
    ];

    programs = {
      firefox.enable = true;
      onlyoffice.enable = true;
      vscode.enable = true;
    };

    services = {
      syncthing.tray.enable = true;
      tailscale-systray.enable = true;
    };
  };
}

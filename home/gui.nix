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

      mpv = {
        enable = true;
        config = {
          vo = "gpu-next";
          hwdec = "auto-safe";
          slang = "chs,sc,zh";
          alang = "jpn,ja,jp";
          sub-auto = "fuzzy";
          fullscreen = "yes";
          idle = "once";
          save-position-on-quit = "yes";
        };
      };
    };
  };
}

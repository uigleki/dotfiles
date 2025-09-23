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
    home.packages = with pkgs; [
      firefox
      qbittorrent-enhanced
    ];

    programs.mpv = {
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
}

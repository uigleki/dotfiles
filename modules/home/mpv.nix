{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.desktop;
in
{
  config = lib.mkIf cfg.enable {
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

      scripts = with pkgs.mpvScripts; [
        mpris
        thumbfast
        uosc
      ];
    };
  };
}

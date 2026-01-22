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

        # required by uosc
        osd-bar = "no";
        border = "no";
      };

      scripts = with pkgs.mpvScripts; [
        mpris
        thumbfast
        uosc
      ];

      bindings = {
        right = "seek 5; script-binding uosc/flash-timeline";
        left = "seek -5; script-binding uosc/flash-timeline";
        "shift+right" = "seek 30; script-binding uosc/flash-timeline";
        "shift+left" = "seek -30; script-binding uosc/flash-timeline";

        m = "no-osd cycle mute; script-binding uosc/flash-volume";
        up = "no-osd add volume 10; script-binding uosc/flash-volume";
        down = "no-osd add volume -10; script-binding uosc/flash-volume";

        "[" = "no-osd add speed -0.25; script-binding uosc/flash-speed";
        "]" = "no-osd add speed 0.25; script-binding uosc/flash-speed";
        "\\" = "no-osd set speed 1; script-binding uosc/flash-speed";

        ">" = "script-binding uosc/next; script-message-to uosc flash-elements top_bar,timeline";
        "<" = "script-binding uosc/prev; script-message-to uosc flash-elements top_bar,timeline";
      };
    };
  };
}

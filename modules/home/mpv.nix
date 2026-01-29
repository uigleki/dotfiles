{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.desktop;
  shaders = "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders";

  anime4k = builtins.concatStringsSep ":" [
    "${shaders}/Anime4K_Clamp_Highlights.glsl" # anti-ringing
    "${shaders}/Anime4K_Restore_CNN_M.glsl" # denoise & restore
    "${shaders}/Anime4K_Upscale_CNN_x2_M.glsl" # 2x upscale
    "${shaders}/Anime4K_AutoDownscalePre_x2.glsl" # downscale if larger than screen
  ];

  fsrcnnx = builtins.concatStringsSep ":" [
    "${shaders}/FSRCNNX_x2_8-0-4-1.glsl" # luma upscale (detail)
    "${shaders}/KrigBilateral.glsl" # chroma upscale (color)
    "${shaders}/SSimDownscaler.glsl" # perceptual downscaler
  ];
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
        idle = "once"; # keep open if no file, quit after playback
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

        "ctrl+`" = ''no-osd change-list glsl-shaders clr ""; show-text "Shaders: Off"'';
        "ctrl+1" = ''no-osd change-list glsl-shaders set "${anime4k}"; show-text "Shaders: Anime4K"'';
        "ctrl+2" = ''no-osd change-list glsl-shaders set "${fsrcnnx}"; show-text "Shaders: FSRCNNX"'';
      };
    };
  };
}

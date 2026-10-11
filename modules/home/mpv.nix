{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.desktop;

  # Anime4K Mode A (Fast), as in the upstream template
  anime = lib.concatStringsSep ":" [
    "~~/shaders/Anime4K_Clamp_Highlights.glsl" # prevent overshoot
    "~~/shaders/Anime4K_Restore_CNN_M.glsl" # denoise & restore
    "~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl" # 2x upscale
    "~~/shaders/Anime4K_AutoDownscalePre_x2.glsl" # fit to screen after the 1st upscale
    "~~/shaders/Anime4K_AutoDownscalePre_x4.glsl" # fit so the 2nd upscale matches screen
    "~~/shaders/Anime4K_Upscale_CNN_x2_S.glsl" # 2nd upscale, low-res sources only
  ];

  film = lib.concatStringsSep ":" [
    "~~/shaders/FSRCNNX_x2_8-0-4-1.glsl" # luma upscale
    "~~/shaders/KrigBilateral.glsl" # chroma upscale
    "~~/shaders/SSimDownscaler.glsl" # perceptual downscaler
  ];
in
{
  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;

      config = {
        profile = "high-quality";
        hwdec = "auto-safe";

        # chs and sc match fansub file suffixes like `.chs.ass`
        slang = "zh-Hans,zh-CN,chs,sc,zh";
        alang = "ja";
        sub-auto = "fuzzy";

        fullscreen = "yes";
        idle = "once"; # keep open if no file, quit after playback
        save-position-on-quit = "yes";

        # uosc draws its own OSD bars and window border
        osd-bar = "no";
        border = "no";
      };

      profiles.no-resume = {
        profile-desc = "Don't resume nearly finished, short or audio-only files";

        profile-cond = lib.concatStringsSep " or " [
          "get('percent-pos', 0) >= 90"
          "get('duration', math.huge) <= 300"
          "not p.vid"
          "p['current-tracks/video/albumart']"
          "p['current-tracks/video/image']"
        ];

        profile-restore = "copy";
        save-position-on-quit = "no";
      };

      # Written by hand, as `bindings` sorts keys and would scramble the order of
      # the uosc menu, which is built from the `#!` comments below.
      extraInput = ''
        mbtn_right  script-binding uosc/menu
        menu        script-binding uosc/menu

        right        seek 5; script-binding uosc/flash-timeline
        left         seek -5; script-binding uosc/flash-timeline
        shift+right  seek 30; script-binding uosc/flash-timeline
        shift+left   seek -30; script-binding uosc/flash-timeline

        m     no-osd cycle mute; script-binding uosc/flash-volume
        up    no-osd add volume 10; script-binding uosc/flash-volume
        down  no-osd add volume -10; script-binding uosc/flash-volume

        [   no-osd add speed -0.25; script-binding uosc/flash-speed
        ]   no-osd add speed 0.25; script-binding uosc/flash-speed
        \   no-osd set speed 1; script-binding uosc/flash-speed

        #  script-binding uosc/open-file  #! Open file
        #  script-binding uosc/playlist   #! Playlist
        #  script-binding uosc/chapters   #! Chapters
        #  script-binding uosc/subtitles  #! Subtitles
        #  script-binding uosc/audio      #! Audio
        >  script-binding uosc/next; script-message-to uosc flash-elements top_bar,timeline  #! Next
        <  script-binding uosc/prev; script-message-to uosc flash-elements top_bar,timeline  #! Previous
        #  #! ---

        ctrl+1  no-osd change-list glsl-shaders set "${anime}"; show-text "Shaders: Anime"  #! Shaders > Anime
        ctrl+2  no-osd change-list glsl-shaders set "${film}"; show-text "Shaders: Film"  #! Shaders > Film
        ctrl+`  no-osd change-list glsl-shaders clr ""; show-text "Shaders: Off"  #! Shaders > Off

        #  script-binding uosc/audio-device       #! Utils > Audio devices
        #  async screenshot                       #! Utils > Screenshot
        #  script-binding uosc/show-in-directory  #! Utils > Show in directory
        #  script-binding uosc/keybinds           #! Utils > Key bindings
        #  #! ---

        q  quit  #! Quit
      '';

      scripts = with pkgs.mpvScripts; [
        mpris
        thumbfast
        uosc
      ];
    };

    xdg.configFile."mpv/shaders".source =
      "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders";
  };
}

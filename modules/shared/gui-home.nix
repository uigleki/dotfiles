{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    ffmpeg
    firefox
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
}

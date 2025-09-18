{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.gui;
in
{
  options.myModules.gui = {
    enable = lib.mkEnableOption "Enable GUI configuration.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
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
  };
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    ffmpeg
  ];
}

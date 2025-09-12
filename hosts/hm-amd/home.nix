{ pkgs, ... }:
{
  imports = [
    ../shared.nix
  ];

  nix.package = pkgs.nix;

  home.packages = with pkgs; [
    claude-code
    ffmpeg
  ];
}

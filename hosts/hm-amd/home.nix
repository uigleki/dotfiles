{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    ffmpeg
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}

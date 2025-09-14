{ pkgs, ... }:
{
  nix = {
    package = pkgs.nix;
    nixpkgs.config.allowUnfree = true;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}

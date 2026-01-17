{ inputs, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      # Expose unstable packages as pkgs.unstable.*
      (final: _: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      })
    ];
  };
}

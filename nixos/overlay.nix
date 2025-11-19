{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) system config;
      };
    })
  ];
}

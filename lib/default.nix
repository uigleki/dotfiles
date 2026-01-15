{ inputs }:
{
  mkHome = import ./mkHome.nix { inherit inputs; };
  mkSystem = import ./mkSystem.nix { inherit inputs; };
}

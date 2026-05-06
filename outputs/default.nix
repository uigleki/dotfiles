inputs@{ flake-parts, systems, ... }:
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = import systems;

  imports = [
    ./dev.nix
    ./hosts.nix
  ];
}

inputs@{ flake-parts, ... }:
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = [
    "aarch64-linux"
    "x86_64-linux"
  ];

  imports = [
    ./dev.nix
    ./hosts.nix
  ];
}

{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.inori.module = {
    imports = [
      nixos.base
      nixos.wsl
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    owner.username = "nixos"; # keep WSL default to avoid home directory migration
  };
}

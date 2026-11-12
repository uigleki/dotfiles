{ config, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.configurations.inori.module = {
    imports = [
      nixos.base
      nixos.wsl
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    owner.username = "nixos"; # keep WSL default to avoid home directory migration
  };
}

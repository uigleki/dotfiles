{ config, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.configurations.inori = {
    imports = [
      nixos.base
      nixos.wsl
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    user.username = "nixos"; # keep WSL default to avoid home directory migration
  };
}

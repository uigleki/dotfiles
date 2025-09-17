{ inputs, ... }:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  wsl.enable = true;
  programs.nix-ld.enable = true;
}

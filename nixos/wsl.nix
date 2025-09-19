{ inputs, ... }:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  wsl.enable = true;
  programs.nix-ld.enable = true;

  myModules = {
    boot.enable = false;
    diskConfig.enable = false;
    network.enable = false;
  };
}

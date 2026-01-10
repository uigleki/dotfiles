{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  wsl.enable = true;

  myModules = {
    boot.enable = false;
    diskConfig.enable = false;
    network.enable = false;
    security.enable = false;
  };

  environment.systemPackages = with pkgs; [
    wget
  ];
}

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.wsl;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  options.myModules.wsl.enable = lib.mkEnableOption "WSL mode";

  config = lib.mkIf cfg.enable {
    wsl.enable = true;

    myModules = {
      disk.enable = false;
      network.enable = false;
      security.enable = false;
    };

    boot.loader.systemd-boot.enable = lib.mkForce false;
    environment.systemPackages = with pkgs; [ wget ];
  };
}

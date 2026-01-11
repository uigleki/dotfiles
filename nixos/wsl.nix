{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.wsl;
in
{
  options.myModules.wsl.enable = lib.mkEnableOption "Enable WSL configuration.";

  config = lib.mkIf cfg.enable {
    wsl.enable = true;

    myModules = {
      boot.enable = false;
      diskConfig.enable = false;
      network.enable = false;
      security.enable = false;
    };

    environment.systemPackages = with pkgs; [ wget ];
  };
}

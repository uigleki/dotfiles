{ config, lib, ... }:
let
  cfg = config.myModules.boot;
in
{
  options.myModules.boot.enable = lib.mkEnableOption "Enable boot configuration." // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
      };
    };
  };
}

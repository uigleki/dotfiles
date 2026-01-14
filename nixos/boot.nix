{ config, lib, ... }:
let
  cfg = config.myModules.boot;
in
{
  options.myModules.boot.enable = lib.mkEnableOption "boot configuration" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
  };
}

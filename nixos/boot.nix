{ config, lib, ... }:
let
  cfg = config.myModules.boot;
in
{
  options.myModules.boot = {
    enable = lib.mkEnableOption "Enable boot configuration." // {
      default = true;
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Timeout for bootloader.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = cfg.timeout;
      };
    };
  };
}

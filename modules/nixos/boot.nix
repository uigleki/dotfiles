{ config, lib, ... }:
let
  cfg = config.myModules.boot;
in
{
  options.myModules.boot.enable = lib.mkEnableOption "bootloader" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}

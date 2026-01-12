{
  config,
  osConfig ? null,
  lib,
  ...
}:
let
  cfg = config.myModules.network;
in
{
  options.myModules.network.enable = lib.mkEnableOption "Enable network configuration." // {
    default = osConfig.myModules.network.enable or false;
  };

  config = lib.mkIf cfg.enable {
    services.syncthing.enable = true;
  };
}

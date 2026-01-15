{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  cfg = config.myModules.network;
in
{
  options.myModules.network.enable = lib.mkEnableOption "network services" // {
    default = osConfig.myModules.network.enable or false;
  };

  config = lib.mkIf cfg.enable {
    services.syncthing.enable = true;
  };
}

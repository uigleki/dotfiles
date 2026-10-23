{ lib, osConfig, ... }:
{
  config = lib.mkIf osConfig.myModules.network.enable {
    services.syncthing.enable = true;
  };
}

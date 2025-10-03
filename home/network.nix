{
  osConfig ? null,
  lib,
  ...
}:
let
  cfg = osConfig.myModules.network or { enable = false; };
in
{
  config = lib.mkIf cfg.enable {
    services.syncthing.enable = true;
  };
}

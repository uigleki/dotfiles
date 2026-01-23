{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.myModules.autoUpdate;
in
{
  options.myModules.autoUpdate.enable = lib.mkEnableOption "automatic upgrades";

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        # update flake inputs without modifying the repo's lock file
        "--recreate-lock-file"
        "--no-write-lock-file"
      ];
    };
  };
}

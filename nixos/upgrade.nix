{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.myModules.autoUpdate;
in
{
  options.myModules.autoUpdate.enable = lib.mkEnableOption "Enable auto upgrade.";

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      # update flake inputs without modifying the repo's lock file
      flags = [
        "--recreate-lock-file"
        "--no-write-lock-file"
      ];
    };
  };
}

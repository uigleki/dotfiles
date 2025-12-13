{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.dev;
in
{
  options.myModules.dev = {
    enable = lib.mkEnableOption "Enable development environment configuration.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_24
      pnpm
      unstable.claude-code
    ];
  };
}

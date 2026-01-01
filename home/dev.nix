{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.dev;
  pnpmHome = "$HOME/.local/share/pnpm";
in
{
  options.myModules.dev = {
    enable = lib.mkEnableOption "Enable development environment configuration.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nodejs_24
        pnpm
        uv
      ];

      sessionPath = [
        "$HOME/.local/bin"
        pnpmHome
      ];

      sessionVariables = {
        PNPM_HOME = pnpmHome;
      };
    };
  };
}

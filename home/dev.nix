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
      sessionVariables = {
        PNPM_HOME = pnpmHome;
      };

      sessionPath = [ pnpmHome ];

      packages = with pkgs; [
        pnpm
      ];
    };
  };
}

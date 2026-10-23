{
  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    let
      settings = {
        onboarding = false;
        theme.name = "catppuccin-latte";

        ui = {
          sidebar.agents.rows = [
            [
              "state_icon"
              "agent"
              "workspace"
            ]
            [ "terminal_title_stripped" ]
          ];

          status_indicators = "symbols";
          toast.delivery = "terminal";
        };

        update.version_check = false;
      };
    in
    {
      home.packages = [ pkgs.unstable.herdr ];

      xdg.configFile."herdr/config.toml" = {
        source = (pkgs.formats.toml { }).generate "herdr-config.toml" settings;
        onChange = "${lib.getExe pkgs.unstable.herdr} server reload-config || true";
      };
    };
}

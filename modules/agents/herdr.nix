{
  homeManager.modules.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.unstable) herdr;
      hook = ".claude/hooks/herdr-agent-state.sh";

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
      home = {
        # herdr reads its integration version from this path and asks to reinstall when it lags the binary;
        # its installer overwrites the path with a regular file
        file.${hook} = {
          force = true;
          source = "${herdr}/share/herdr/integrations/claude/herdr-agent-state.sh";
        };

        packages = [ herdr ];
      };

      # what `herdr integration install claude` would add
      programs.claude-code.settings.hooks.SessionStart = [
        {
          hooks = [
            {
              type = "command";
              command = "bash '${config.home.homeDirectory}/${hook}' session";
              timeout = 10;
            }
          ];
        }
      ];

      xdg.configFile."herdr/config.toml" = {
        source = (pkgs.formats.toml { }).generate "herdr-config.toml" settings;
        onChange = "${lib.getExe herdr} server reload-config || true";
      };
    };
}

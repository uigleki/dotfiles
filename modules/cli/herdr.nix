{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.unstable) herdr;

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
        file.".claude/hooks/herdr-agent-state.sh" = {
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
              command = "bash '${config.home.homeDirectory}/.claude/hooks/herdr-agent-state.sh' session";
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

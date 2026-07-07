{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    enableMcpIntegration = true;

    settings = {
      agentPushNotifEnabled = true;
      askUserQuestionTimeout = "10m";
      enableWorkflows = true;
      enabledPlugins."superpowers@claude-plugins-official" = true;
      inputNeededNotifEnabled = true;
      model = "opus";
      permissions.defaultMode = "auto";
      remoteControlAtStartup = true;
      theme = "auto";

      attribution = {
        commit = "";
        pr = "";
        sessionUrl = false;
      };

      env = {
        CLAUDE_AUTOCOMPACT_PCT_OVERRIDE = 70;
        CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = 1;
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = 1;
        DISABLE_ERROR_REPORTING = 1;
        DISABLE_FEEDBACK_COMMAND = 1;
      };

      hooks.PreToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "rtk hook claude";
            }
          ];
        }
      ];
    };
  };
}

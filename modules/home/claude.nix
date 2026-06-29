{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    enableMcpIntegration = true;

    settings = {
      agentPushNotifEnabled = true;
      enabledPlugins."superpowers@claude-plugins-official" = true;
      feedbackSurveyRate = 0;
      model = "opus";
      permissions.defaultMode = "auto";
      remoteControlAtStartup = true;
      theme = "auto";

      env = {
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

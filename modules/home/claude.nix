{ pkgs, ... }:
let
  statuslineFilter = pkgs.writeText "claude-statusline.jq" ''
    def rateSeg($label): if . then ["\($label) \(round)%"] else [] end;

    (.workspace.current_dir | split("/") | last) as $dir |
    .model.display_name as $model |
    .effort.level as $effort |
    (if $effort then "\($model) \($effort)" else $model end) as $modelseg |
    ((.context_window.total_input_tokens // 0) / 1000 | round) as $uk |
    ((.context_window.context_window_size // 200000) / 1000 | round) as $mk |
    (.context_window.used_percentage // 0 | round) as $pct |
    [ "\($dir) · \($modelseg) · \($uk)k/\($mk)k \($pct)%" ]
      + (.rate_limits.five_hour.used_percentage | rateSeg("5h"))
      + (.rate_limits.seven_day.used_percentage | rateSeg("7d"))
    | join(" · ")
  '';
in
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

      statusLine = {
        type = "command";
        command = "${pkgs.jq}/bin/jq -j -f ${statuslineFilter}";
      };
    };
  };
}

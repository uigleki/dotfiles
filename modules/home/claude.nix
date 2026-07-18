{ lib, pkgs, ... }:
let
  statuslineFilter = pkgs.writeText "claude-statusline.jq" ''
    def human: (. / 1000 | round) as $k
      | if $k >= 1000 then "\(. / 100000 | round / 10)M" else "\($k)k" end;

    def rate_seg($label; $fmt):
      values | "\($label) \(.used_percentage | round)% (\(.resets_at | strflocaltime($fmt)))";

    [ (.workspace.current_dir | split("/") | last),
      ([ .model.display_name, (.effort.level // empty), (select(.fast_mode) | "fast") ] | join(" ")),
      (.context_window | "\(.total_input_tokens // 0 | human)/\(.context_window_size // 200000 | human) \(.used_percentage // 0 | round)%"),
      (.rate_limits.five_hour | rate_seg("5h"; "%H:%M")),
      (.rate_limits.seven_day | rate_seg("7d"; "%a %H:%M")) ]
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
        command = "${lib.getExe pkgs.jq} -j -f ${statuslineFilter}";
      };
    };
  };
}

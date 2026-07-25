{ lib, pkgs, ... }:
let
  statuslineFilter = pkgs.writeTextFile {
    name = "claude-statusline.jq";
    checkPhase = ''${lib.getExe pkgs.jq} -n -f "$target"'';

    text = ''
      def human: if . < 1e6 then "\(./1e3|round)k" else "\(./1e5|round/10)M" end;
      def rate($l; $f): values | "\($l) \(.used_percentage|round)% (\(.resets_at|strflocaltime($f)))";
      [ ([ "[\(.model.display_name)]", (.effort.level // empty), (select(.fast_mode)|"fast") ] | join(" ")),
        (.context_window | "\(.used_percentage // 0 | round)% (\(.total_input_tokens // 0 | human)/\(.context_window_size // 2e5 | human))"),
        (.rate_limits.five_hour | rate("5h"; "%H:%M")),
        (.rate_limits.seven_day | rate("7d"; "%a %H:%M")),
        (.workspace.current_dir // empty | sub("^\($ENV.HOME)(?=/|$)"; "~"))
      ] | join(" · ")
    '';
  };
in
{
  programs.claude-code = {
    enable = true;
    package = null; # bun add -g @anthropic-ai/claude-code

    settings = {
      agentPushNotifEnabled = true;
      askUserQuestionTimeout = "10m";
      inputNeededNotifEnabled = true;
      model = "opus";
      permissions.defaultMode = "auto";
      remoteControlAtStartup = true;
      theme = "auto";
      tui = "fullscreen";

      attribution = {
        commit = "";
        pr = "";
        sessionUrl = false;
      };

      env = {
        CLAUDE_AUTOCOMPACT_PCT_OVERRIDE = 75;
        CLAUDE_CODE_AUTO_COMPACT_WINDOW = 400000;
        CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = 1;
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = 1;
        CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION = 1000;
        CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION = 1000;
        CLAUDE_CODE_RETRY_WATCHDOG = 1;
        DISABLE_ERROR_REPORTING = 1;
        DISABLE_FEEDBACK_COMMAND = 1;
      };

      statusLine = {
        type = "command";
        command = "${lib.getExe pkgs.jq} -r -f ${statuslineFilter}";
      };
    };
  };
}

{ lib, pkgs, ... }:
let
  jq = lib.getExe pkgs.jq;
  statuslineFilter = pkgs.writeTextFile {
    name = "claude-statusline.jq";
    checkPhase = ''${jq} -n -f "$target"'';

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
      model = "claude-fable-5-1[1m]";
      env.CLAUDE_CODE_SUBAGENT_MODEL = "opus[1m]";

      agentPushNotifEnabled = false;
      autoMemoryEnabled = false;
      disableBundledSkills = true;
      disableClaudeAiConnectors = true;
      disableWorkflows = true;
      inputNeededNotifEnabled = true;
      remoteControlAtStartup = true;
      theme = "auto";
      tui = "fullscreen";
      worktree.baseRef = "head";

      attribution = {
        commit = "";
        pr = "";
        sessionUrl = false;
      };

      env = {
        CLAUDE_AUTOCOMPACT_PCT_OVERRIDE = 75;
        CLAUDE_CODE_AUTO_COMPACT_WINDOW = 400000;
        CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = 1;
        CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH = 1;
        CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION = 1000;
        CLAUDE_CODE_RETRY_WATCHDOG = 1;
        DISABLE_ERROR_REPORTING = 1;
        DISABLE_FEEDBACK_COMMAND = 1;
      };

      permissions = {
        defaultMode = "auto";
        deny = [
          "Artifact"
          "AskUserQuestion"
          "CronCreate"
          "CronDelete"
          "CronList"
          "DesignSync"
          "EnterPlanMode"
          "ExitPlanMode"
          "NotebookEdit"
          "PushNotification"
          "RemoteTrigger"
          "ReportFindings"
          "ScheduleWakeup"
        ];
      };

      statusLine = {
        type = "command";
        command = "${jq} -r -f ${statuslineFilter}";
      };
    };
  };
}

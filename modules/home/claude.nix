# curl -fsSL https://claude.ai/install.sh | bash
{ lib, pkgs, ... }:
let
  jq = lib.getExe pkgs.jq;
  statuslineFilter = pkgs.writeTextFile {
    name = "claude-statusline.jq";
    checkPhase = ''${jq} -n -f "$target"'';
    text = builtins.readFile ./claude-statusline.jq;
  };
in
{
  programs.claude-code = {
    enable = true;
    package = null;

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

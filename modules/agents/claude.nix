# curl -fsSL https://claude.ai/install.sh | bash
{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.home) homeDirectory;
      jq = lib.getExe pkgs.jq;

      statuslineFilter = pkgs.writeTextFile {
        name = "claude-statusline.jq";
        checkPhase = ''${jq} -n -f "$target"'';
        text = builtins.readFile ./claude-statusline.jq;
      };
    in
    {
      programs = {
        claude-code = {
          enable = true;
          package = null;

          # cloud sessions read only the repo's .claude/settings.json; mirror behavior-changing keys there
          settings = {
            # retuned often; uncomment the subagent model while model is Fable:
            # its quota is half the weekly limit and drains fast
            model = "opus[1m]";
            # env.CLAUDE_CODE_SUBAGENT_MODEL = "opus[1m]";

            agentPushNotifEnabled = false;
            attribution = false;
            autoMemoryEnabled = false;
            awaySummaryEnabled = false;
            disableClaudeAiConnectors = true;
            disableWorkflows = true;

            env = {
              # compacts at 300k (33k below the window): context rot degrades output long before 1M
              CLAUDE_CODE_AUTO_COMPACT_WINDOW = 333000;
              CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = 1;
              CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS = 10;
              CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH = 2;
              CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION = 1000;
              CLAUDE_CODE_RETRY_WATCHDOG = 1;
              DISABLE_ERROR_REPORTING = 1;
              DISABLE_FEEDBACK_COMMAND = 1;
            };

            hooks.SessionStart = [
              {
                hooks = [
                  {
                    type = "command";
                    # a Claude worktree's .envrc starts blocked
                    command = ''cd "''${CLAUDE_PROJECT_DIR%%/.claude/worktrees/*}" && direnv export bash > "$CLAUDE_ENV_FILE"'';
                  }
                ];
              }
              {
                matcher = "^(startup|resume|clear|compact|fork)$";
                hooks = [
                  {
                    type = "command";
                    command = "bash '${homeDirectory}/.claude/hooks/herdr-agent-state.sh' session";
                    timeout = 10;
                  }
                ];
              }
            ];

            inputNeededNotifEnabled = true;

            permissions = {
              # only claude -p needs this: interactive sessions already default to auto
              defaultMode = "auto";

              deny = [
                # denied rather than enableArtifact = false, which also drops the session scratchpad
                "Artifact"
                # mid-turn questions either stall unattended runs or time out into a guess
                "AskUserQuestion"
                # auto mode replaces the plan-then-approve loop
                "EnterPlanMode"
                "ExitPlanMode"
                # makes /code-review fork a fresh reviewer even when driven from the app or claude.ai
                "ReportFindings"
              ];
            };

            promptSuggestionEnabled = false;
            remoteControlAtStartup = true;
            spinnerTipsEnabled = false;

            statusLine = {
              type = "command";
              command = "${jq} -r -f ${statuslineFilter}";
            };

            syncClaudeAiSkills = false;
            theme = "auto";
            tui = "fullscreen";
          };
        };

        git.ignores = [
          # Claude Code adds it on first writing the file
          "**/.claude/settings.local.json"
          # Claude Code adds it only once a scheduled task runs
          "**/.claude/worktrees/"
        ];
      };
    };
}

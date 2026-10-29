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
      programs.claude-code = {
        enable = true;
        package = null;

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
            CLAUDE_AUTOCOMPACT_PCT_OVERRIDE = 75;
            CLAUDE_CODE_AUTO_COMPACT_WINDOW = 400000;
            CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = 1;
            CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS = 10;
            CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH = 2;
            CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION = 1000;
            CLAUDE_CODE_RETRY_WATCHDOG = 1;
            DISABLE_ERROR_REPORTING = 1;
            DISABLE_FEEDBACK_COMMAND = 1;
          };

          hooks = {
            CwdChanged = [
              {
                hooks = [
                  {
                    type = "command";
                    command = ''direnv export bash > "$CLAUDE_ENV_FILE"'';
                  }
                ];
              }
            ];

            SessionStart = [
              {
                hooks = [
                  {
                    type = "command";
                    command = ''direnv export bash > "$CLAUDE_ENV_FILE"'';
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
          };

          inputNeededNotifEnabled = true;

          permissions = {
            defaultMode = "auto";

            deny = [
              "Artifact"
              "AskUserQuestion"
              "DesignSync"
              "EnterPlanMode"
              "ExitPlanMode"
              "NotebookEdit"
              "PushNotification"
              "ReportFindings"
            ];
          };

          promptSuggestionEnabled = false;
          remoteControlAtStartup = true;

          # Hide bundled skills that would only waste the skill listing here.
          skillOverrides =
            lib.genAttrs [
              # Artifact is denied above
              "artifact-capabilities"
              "artifact-design"
              "artifact-diagramming"
              "dataviz"
              "fewer-permission-prompts" # auto mode already skips most prompts
              "keybindings-help"
              "plugin-authoring"
              "update-config" # settings.json is a read-only Nix store link
            ] (_: "off")
            # still typable as /name, but kept out of the model's skill listing
            // lib.genAttrs [
              "init"
              "security-review"
            ] (_: "user-invocable-only");

          spinnerTipsEnabled = false;

          statusLine = {
            type = "command";
            command = "${jq} -r -f ${statuslineFilter}";
          };

          syncClaudeAiSkills = false;
          theme = "auto";
          tui = "fullscreen";
          worktree.baseRef = "head";
        };
      };
    };
}

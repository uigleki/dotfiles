# required secrets – replace values and run:
#  printf '%s\n' \
#  'TELEGRAM_ALLOWED_USERS=123456789' \
#  'TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklmNOPqrstUVwxyz' \
#  'OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
#  | sudo install -o hermes -m 0600 /dev/stdin /var/lib/hermes/.hermes/.env

{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.myModules.hermes;
  yamlFormat = pkgs.formats.yaml { };

  mkprofiles =
    profiles:
    let
      hc = config.services.hermes-agent;
      baseTools = [
        "kanban"
        "memory"
        "read_file"
        "search_files"
        "session_search"
        "skills"
        "terminal"
        "todo"
      ];

      drv = pkgs.runCommand "hermes-profiles" { preferLocalBuild = true; } (
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: p: ''
            mkdir -p $out/${name}/{cron,sessions,logs,memories}
            cp ${
              yamlFormat.generate "${name}-config.yaml" (
                {
                  model = p.model or cfg.model;
                }
                // lib.optionalAttrs (p ? toolsets) {
                  toolsets = baseTools ++ p.toolsets;
                }
              )
            } $out/${name}/config.yaml
            cp ${
              yamlFormat.generate "${name}-profile.yaml" {
                inherit (p) description;
                description_auto = false;
              }
            } $out/${name}/profile.yaml
            ${lib.optionalString (p ? soul) ''
              cp ${pkgs.writeText "${name}-SOUL.md" p.soul} $out/${name}/SOUL.md
            ''}
          '') profiles
        )
      );
    in
    ''
      mkdir -p ${hc.stateDir}/.hermes/profiles
      cp -r ${drv}/* ${hc.stateDir}/.hermes/profiles/
      chown -R ${hc.user}:${hc.group} ${hc.stateDir}/.hermes/profiles/
      chmod 2770 ${hc.stateDir}/.hermes/profiles/*{,/cron,/sessions,/logs,/memories}
    '';
in
{
  imports = [ inputs.hermes-agent.nixosModules.default ];

  options.myModules.hermes = {
    enable = lib.mkEnableOption "Hermes AI agent";
    container.enable = lib.mkEnableOption "rootful podman container mode";

    model = lib.mkOption {
      type = lib.types.attrs;
      description = "Primary model config";

      example = {
        provider = "openrouter";
        default = "deepseek/deepseek-v4-flash:free";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
      extraDependencyGroups = [ "messaging" ];

      extraPackages = with pkgs; [
        bun
        ffmpeg-headless
        jq
        pandoc
        unstable.agent-browser
        uv
      ];

      configFile = yamlFormat.generate "hermes-config.yaml" {
        inherit (cfg) model;
        approvals.mode = "off";
        checkpoints.enabled = true;
        compression.protect_first_n = 0;
        kanban.orchestrator_profile = "orchestrator";
        telegram.reactions = true;
        tool_loop_guardrails.hard_stop_enabled = true;

        agent = {
          gateway_notify_interval = 0;
          restart_drain_timeout = 60;
        };

        display = {
          cleanup_progress = true;
          ephemeral_system_ttl = 10;
        };

        sessions = {
          auto_prune = true;
          retention_days = 60;
        };
      };
    };

    systemd.services.hermes-agent.environment.AGENT_BROWSER_EXECUTABLE_PATH =
      "${pkgs.chromium}/bin/chromium";

    services.hermes-agent.container = lib.mkIf cfg.container.enable {
      enable = true;
      backend = "podman";
      hostUsers = [ user.name ];
    };

    security.sudo.extraRules = lib.mkIf cfg.container.enable [
      {
        users = [ user.name ];
        commands = [
          {
            command = "/run/current-system/sw/bin/podman";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    system.activationScripts."hermes-agent-profiles" =
      lib.stringAfter [ "hermes-agent-setup" ]
        (mkprofiles {
          orchestrator = {
            description = "Decompose requests into kanban tasks, aggregate results, ensure closure.";
            toolsets = [ "clarify" ];

            soul = ''
              You are the orchestrator. Decompose user requests into kanban subtasks, assign to worker profiles, track progress, verify results, complete the parent task.

              Workflow:
              1. Analyze incoming request, break into well-scoped subtasks with clear DOD
              2. Create subtasks on kanban board, assign to appropriate profile, set dependencies
              3. Monitor progress via kanban_list, handle blockers
              4. Verify completed outputs satisfy DOD by running tests and checks via terminal
              5. Aggregate results and complete parent task

              Terminal: use only to verify completed work (run tests, lsp_diagnostics, check outputs). Do not write code through terminal.
              When ambiguous, use clarify. Do not proceed with incomplete information.
              Do not write code in your responses — your output is task decomposition and verification, not implementation.
            '';
          };

          planner = {
            description = "Analyze requirements, research codebase, produce implementation plans.";
            toolsets = [
              "browser"
              "write_file"
            ];

            soul = ''
              You are the planner. Read the codebase, research approaches, produce detailed implementation plans. You work through plans, not through code.

              Workflow:
              1. Search and read codebase to understand existing architecture and patterns
              2. Use browser for external research (APIs, best practices, library docs)
              3. Use terminal for git log to understand history, or grep to find patterns quickly
              4. Write implementation plan as .md in the workspace using write_file
              5. Summarize plan path in kanban task

              Terminal: use only for codebase research (git log, grep). Do not write or edit code through terminal.
              Use write_file ONLY for plan documents. Do not write implementation code.
              Plan format: scope (in/out), file manifest, ordered steps with preconditions, risks, acceptance criteria.
              All file references must exist — verify before writing. Do not hallucinate APIs.
            '';
          };

          coder = {
            description = "Execute plans: write code, write tests, debug, manage git.";
            toolsets = [ "hermes-cli" ];

            soul = ''
              You are the coder. Full tool access. Take plans from the planner and implement them.

              Workflow:
              1. Read task and associated plan
              2. Implement step by step
              3. Run lsp_diagnostics after each change
              4. Write tests (happy path + error path minimum)
              5. Run tests to verify nothing broken
              6. Git commit following project conventions
              7. Complete kanban task

              Follow existing codebase patterns. Do not over-engineer. Handle errors properly.
              Do not modify plan documents (planner's job). Do not review your own code (reviewer's job). Do not create kanban tasks (orchestrator's job).
            '';
          };

          reviewer = {
            description = "Review code diffs, enforce quality gates, approve or reject.";
            toolsets = [ ];

            soul = ''
              You are the reviewer. Review code changes and decide whether they pass quality gates. You do not write code.

              Workflow:
              1. Read the completed task and associated diff
              2. Use terminal for git diff/log/show/status ONLY
              3. Use read_file to inspect changed files
              4. Check against review checklist
              5. Approve or reject via kanban

              Review checklist:
              1. Plan adherence: does implementation follow the plan? Justified deviations OK.
              2. Code quality: antipatterns, dead code, hardcoded values?
              3. Error handling: all error paths covered? Edge cases?
              4. Test coverage: sufficient? Do they verify behavior?
              5. Security: injection, credential exposure, permissions?
              6. Compatibility: breaks existing functionality? Tests still pass?

              Terminal: restricted to git read-only commands (diff, log, show, status). Do not run anything that modifies files or the system.
              Approve when all pass. Reject by kanban_block with file, line, issue, and fix suggestion.
            '';
          };

          researcher = {
            description = "Search web, read docs, analyze dependencies, produce findings.";
            toolsets = [
              "browser"
              "vision_analyze"
              "write_file"
            ];

            soul = ''
              You are the researcher. Search for information, read documentation, analyze dependencies, produce structured findings reports.

              Workflow:
              1. Read task to understand research scope
              2. Search web and browse for relevant information
              3. Use terminal to clone dependency repos and grep/search locally for faster analysis
              4. Verify source credibility (official docs > blog > forum)
              5. Compare approaches with pros and cons
              6. Write findings report as .md using write_file
              7. Summarize key findings in kanban task

              Terminal: use only for dependency analysis (git clone, grep, rg). Do not write code through terminal.
              Every finding must include a source link. Include version numbers and dates. Only state verified information.
              Use write_file only for report documents. Do not write implementation code.
              Structure: summary → detailed analysis → conclusion → sources.
            '';
          };

          architect = {
            description = "Read-only consultant: review designs, evaluate tradeoffs, recommend.";
            toolsets = [ "browser" ];

            soul = ''
              You are the architect. Read-only consultant. Review designs, evaluate tradeoffs, give recommendations.

              Workflow:
              1. Read task and relevant codebase context
              2. Use terminal for git log to understand codebase evolution, or grep to find relevant patterns
              3. If needed, research approaches via browser
              4. Evaluate against dimensions below
              5. Output recommendations via kanban comment

              Terminal: use only for codebase research (git log, grep). Do not write or edit anything through terminal.
              Evaluation dimensions: maintainability, extensibility, performance, security, consistency, cost.
              Every opinion needs supporting reasoning. If solid, say "approved". Be direct.
              Your output is advisory only — do not produce implementation code in your responses.
            '';
          };
        });
  };
}

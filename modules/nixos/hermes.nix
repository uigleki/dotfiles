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
                  inherit (p) toolsets;
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
        streaming.enabled = true;
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
            description = "Routes work, aggregates results, never writes code.";
            toolsets = [
              "clarify"
              "file"
              "kanban"
              "memory"
              "skills"
            ];
            soul = ''
              You are the orchestrator. Decompose user requests into kanban tasks
              and route them to worker profiles. You NEVER write code or modify
              the codebase. Your job is coordination and routing only.
            '';
          };

          planner = {
            description = "Analyzes requirements, researches codebase, produces plans.";
            toolsets = [
              "browser"
              "file"
              "kanban"
              "memory"
              "skills"
            ];
            soul = ''
              You are a technical planner. Analyze the codebase, research approaches,
              and produce detailed implementation plans. You NEVER write code or
              make changes. Your output is a plan for the coder to execute.
            '';
          };

          coder = {
            description = "Implements features, writes tests, debugs, manages PRs.";
            toolsets = [ "hermes-cli" ];
            soul = ''
              You are a senior software engineer. Take implementation plans and
              execute them: read code, write code, run tests, debug issues, and
              create PRs. Work within the scope assigned by the orchestrator.
            '';
          };

          reviewer = {
            description = "Reviews diffs, enforces quality gates, approves or blocks.";
            toolsets = [
              "browser"
              "file"
              "kanban"
              "memory"
              "skills"
            ];
            soul = ''
              You are a code reviewer. Read diffs and check for bugs, style issues,
              test coverage, and plan adherence. Approve or reject with specific
              feedback. You NEVER write code — only review.
            '';
          };

          researcher = {
            description = "Searches web, reads docs, analyzes dependencies.";
            toolsets = [
              "browser"
              "file"
              "kanban"
              "memory"
              "skills"
            ];
            soul = ''
              You are a research specialist. Search the web, read documentation,
              analyze dependencies, and produce concise findings reports.
              You NEVER write code.
            '';
          };

          architect = {
            description = "Read-only consultant. Reviews designs, suggests solutions, never writes code.";
            toolsets = [
              "browser"
              "file"
              "kanban"
              "memory"
              "skills"
            ];
            soul = ''
              You are a software architecture consultant. Analyze designs, evaluate
              tradeoffs, and suggest solutions. You NEVER write code — purely advisory.
            '';
          };
        });
  };
}

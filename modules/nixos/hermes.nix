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
  soulsDir = ./souls;

  mkprofiles =
    profiles:
    let
      hc = config.services.hermes-agent;
      baseTools = [
        "kanban"
        "memory"
        "session_search"
        "skills"
        "todo"
      ];

      drv = pkgs.runCommand "hermes-profiles" { preferLocalBuild = true; } (
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: p: ''
            mkdir -p $out/${name}/{cron,sessions,logs,memories}
            cp ${
              yamlFormat.generate "${name}-config.yaml" {
                model = p.model or cfg.model;
                toolsets = baseTools ++ (p.toolsets or [ ]);
              }
            } $out/${name}/config.yaml
            cp ${
              yamlFormat.generate "${name}-profile.yaml" {
                inherit (p) description;
                description_auto = false;
              }
            } $out/${name}/profile.yaml
            cp ${soulsDir}/${name}.md $out/${name}/SOUL.md
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
            description = "Routes tasks to the right agent by capability. Never executes — pure coordination. Decides who handles what and in what order.";
            toolsets = [ "clarify" ];
          };

          planner = {
            description = "Decomposes goals into executable step sequences with explicit dependencies. Requires research input before planning. Does not gather information or execute.";
            toolsets = [ ];
          };

          researcher = {
            description = "Gathers facts, sources, and situational context. Outputs structured knowledge. Makes no decisions or recommendations — pure information gathering.";
            toolsets = [
              "browser"
              "file"
              "terminal"
              "web"
            ];
          };

          coder = {
            description = "Implements logic and makes software run. Writes code, debugs, runs tests. Does not design test strategy or perform security review.";
            toolsets = [
              "file"
              "terminal"
            ];
          };

          writer = {
            description = "Produces written content: documents, reports, articles, copy. Crafts language for clarity, structure, and impact. Does not code or design.";
            toolsets = [ "file" ];
          };

          critic = {
            description = "Finds problems, questions assumptions, identifies flaws. Never suggests solutions — pure qualitative criticism. Separated from binary pass/fail verification.";
            toolsets = [ "file" ];
          };

          verifier = {
            description = "Binary pass/fail verification against defined criteria. Checks if output meets acceptance standards. Makes no qualitative assessment or suggestions.";
            toolsets = [
              "file"
              "terminal"
            ];
          };

          explorer = {
            description = "Explores unknown possibilities, evaluates feasibility, charts potential paths. Operates when the solution space is not well understood. Hands off promising directions to specialists.";
            toolsets = [
              "browser"
              "file"
              "terminal"
              "web"
            ];
          };
        });
  };
}

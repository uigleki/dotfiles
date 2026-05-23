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
        ffmpeg
        jq
        pandoc
        unstable.agent-browser
        uv
      ];

      configFile = yamlFormat.generate "hermes-config" {
        inherit (cfg) model;
        agent.gateway_notify_interval = 0;
        checkpoints.enabled = true;
        compression.protect_first_n = 0;
        kanban.orchestrator_profile = "orchestrator";
        streaming.enabled = true;
        telegram.reactions = true;
        tool_loop_guardrails.hard_stop_enabled = true;

        approvals = {
          gateway_timeout = 60;
          mode = "smart";
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

    services.hermes-agent.settings.container = lib.mkIf cfg.container.enable {
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
  };
}

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
  ...
}:
let
  cfg = config.myModules.hermes;
in
{
  imports = [ inputs.hermes-agent.nixosModules.default ];

  options.myModules.hermes = {
    enable = lib.mkEnableOption "Hermes AI agent";
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
        chromium
        jq
        unstable.agent-browser
        uv
      ];

      settings = {
        inherit (cfg) model;
        checkpoints.enabled = true;
        compression.protect_first_n = 0;
        streaming.enabled = true;
        telegram.reactions = true;
        tool_loop_guardrails.hard_stop_enabled = true;

        agent = {
          gateway_notify_interval = 0;
          max_turns = 200;
        };

        approvals = {
          gateway_timeout = 60;
          mode = "smart";
        };

        delegation = {
          child_timeout_seconds = 3600;
          max_concurrent_children = 5;
          max_iterations = 100;
          max_spawn_depth = 2;
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
  };
}

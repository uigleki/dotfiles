# required secrets – replace values and run:
#  printf '%s\n' \
#  'TELEGRAM_ALLOWED_USERS=123456789' \
#  'TELEGRAM_BOT_TOKEN=1234567890:ABCdef123...' \
#  'OPENCODE_GO_API_KEY=sk-ABCdef123...' \
#  'FIRECRAWL_API_KEY=fc-ABCdef123...' \
#  'TAVILY_API_KEY=tvly-dev-ABCdef123...' \
#  | sudo install -o hermes -g hermes -m 0640 /dev/stdin /var/lib/hermes/.hermes/.env

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

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "Hermes settings";
      default = { };

      example = {
        model = {
          provider = "opencode-go";
          default = "deepseek-v4-flash";
        };

        auxiliary.vision = {
          provider = "opencode-go";
          model = "kimi-k2.6";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;

      extraDependencyGroups = [
        "edge-tts"
        "firecrawl"
        "messaging"
      ];

      extraPythonPackages = with pkgs.python312Packages; [ numpy ];

      extraPackages = with pkgs; [
        agent-browser
        bun
        ffmpeg-headless
        gh
        jq
        pandoc
        uv
      ];

      configFile = yamlFormat.generate "hermes-config.yaml" (
        lib.recursiveUpdate {
          approvals.mode = "off";
          checkpoints.enabled = true;
          compression.protect_first_n = 0;
          memory.provider = "holographic";
          plugins.hermes-memory-store.auto_extract = true;
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
        } cfg.settings
      );
    };

    users.users.${user.name}.extraGroups = [ "hermes" ];

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
  };
}

# required secrets – replace values and run:
#  printf '%s\n' \
#  'TELEGRAM_ALLOWED_USERS=123456789' \
#  'TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklmNOPqrstUVwxyz' \
#  'OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
#  | sudo -u hermes tee /var/lib/hermes/.hermes/.env >/dev/null

{
  config,
  inputs,
  lib,
  user,
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

      container = {
        enable = true;
        backend = "podman";
        hostUsers = [ user.name ];
      };

      settings = {
        inherit (cfg) model;
        approvals.mode = "smart";
        compression.protect_first_n = 0;
        sessions.auto_prune = true;
        streaming.enabled = true;
        tool_loop_guardrails.hard_stop_enabled = true;

        display = {
          cleanup_progress = true;
          ephemeral_system_ttl = 10;
        };
      };
    };
  };
}

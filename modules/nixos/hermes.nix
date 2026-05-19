# required secrets – replace values and run:
#   sudo -u hermes tee /var/lib/hermes/.hermes/.env >/dev/null <<'EOF'
#   TELEGRAM_ALLOWED_USERS=123456789
#   TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklmNOPqrstUVwxyz
#   OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#   OPENCODE_API_KEY=ocz_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#   EOF

{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.myModules.hermes;
in
{
  imports = [ inputs.hermes-agent.nixosModules.default ];

  options.myModules.hermes = {
    enable = lib.mkEnableOption "Hermes AI agent";

    fallbackModel = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      example = [
        {
          provider = "opencode-zen";
          model = "v4-flash-free";
        }
      ];
      description = "Fallback model chain (fallback_model in config.yaml)";
    };

    model = lib.mkOption {
      type = lib.types.attrs;
      example = {
        provider = "openrouter";
        default = "deepseek/deepseek-v4-flash:free";
      };
      description = "Primary model config";
    };

    providers = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = {
        opencode-zen = {
          name = "OpenCode Zen";
          api = "https://opencode.ai/zen/v1";
          key_env = "OPENCODE_API_KEY";
        };
      };
      description = "Custom providers (providers key in config.yaml)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
      extraDependencyGroups = [ "messaging" ];

      settings = {
        inherit (cfg) providers model;
        fallback_model = cfg.fallbackModel;
        telegram.reactions = true;

        display = {
          streaming = true;
          runtime_footer.enabled = true;
        };
      };
    };
  };
}

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

  options.myModules.hermes.enable = lib.mkEnableOption "Hermes AI agent";

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
      extraDependencyGroups = [ "messaging" ];

      settings = {
        telegram.reactions = true;

        display = {
          streaming = true;
          runtime_footer.enabled = true;
        };

        providers = lib.mkDefault {
          opencode-zen = {
            name = "OpenCode Zen";
            api = "https://opencode.ai/zen/v1";
            key_env = "OPENCODE_API_KEY";
          };

          opencode-go = {
            name = "OpenCode Go";
            api = "https://opencode.ai/zen/go/v1";
            key_env = "OPENCODE_API_KEY";
          };
        };

        model = lib.mkDefault {
          default = "deepseek/deepseek-v4-flash:free";
          provider = "openrouter";
        };

        fallback_model = lib.mkDefault [
          {
            provider = "opencode-zen";
            model = "v4-flash-free";
          }
          {
            provider = "opencode-go";
            model = "deepseek-v4-flash";
          }
          {
            provider = "openrouter";
            model = "deepseek/deepseek-v4-flash";
          }
        ];
      };
    };
  };
}

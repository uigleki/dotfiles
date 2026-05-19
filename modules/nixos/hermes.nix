# required secrets – replace values and run:
#   sudo -u hermes tee /var/lib/hermes/.hermes/.env >/dev/null <<'EOF'
#   TELEGRAM_ALLOWED_USERS=123456789
#   TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklmNOPqrstUVwxyz
#   OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#   OPENCODE_ZEN_API_KEY=ocz_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#   OPENCODE_GO_API_KEY=ocz_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
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

      settings = {
        inherit (cfg) model;
        telegram.reactions = true;
      };
    };
  };
}

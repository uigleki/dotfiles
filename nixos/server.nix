{ config, lib, ... }:
let
  cfg = config.myModules.server;
in
{
  options.myModules.server.enable = lib.mkEnableOption "Enable server configuration.";

  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          PubkeyAuthentication = true;
        };
      };

      fail2ban.enable = true;
    };
  };
}

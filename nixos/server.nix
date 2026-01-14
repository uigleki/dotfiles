{ config, lib, ... }:
let
  cfg = config.myModules.server;
in
{
  options.myModules.server.enable = lib.mkEnableOption "server mode";

  config = lib.mkIf cfg.enable {
    services = {
      fail2ban.enable = true;

      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          PubkeyAuthentication = true;
        };
      };
    };
  };
}

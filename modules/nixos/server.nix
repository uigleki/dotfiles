{ config, lib, ... }:
let
  cfg = config.myModules.server;
in
{
  options.myModules.server.enable = lib.mkEnableOption "headless server";

  config = lib.mkIf cfg.enable {
    environment.variables.TERM = "xterm-256color"; # fix missing remote terminfo

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

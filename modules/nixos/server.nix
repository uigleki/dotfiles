{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.server;
in
{
  options.myModules.server.enable = lib.mkEnableOption "headless server";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kitty.terminfo ]; # ssh from kitty keeps TERM=xterm-kitty

    services = {
      fail2ban.enable = true;

      # pin defaults that would lock us out of the VPS if they flipped
      openssh = {
        enable = true;
        openFirewall = true;

        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          PubkeyAuthentication = true;
        };
      };
    };
  };
}

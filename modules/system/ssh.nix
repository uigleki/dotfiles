{ config, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.modules.server =
    { config, lib, ... }:
    {
      imports = with nixos; [
        base
        hardening
        network
      ];

      environment.persistence."/persist" = {
        directories = [ "/var/lib/fail2ban" ];

        # a new host key breaks known_hosts on every client and deploy
        files = lib.concatMap (key: [
          key.path
          "${key.path}.pub"
        ]) config.services.openssh.hostKeys;
      };

      services = {
        fail2ban.enable = true;

        # pin defaults that would lock us out of the VPS if they flipped
        openssh = {
          enable = true;
          openFirewall = true;

          settings = {
            KbdInteractiveAuthentication = false;
            PasswordAuthentication = false;
            PermitRootLogin = "no";
            PubkeyAuthentication = true;
          };
        };
      };
    };
}

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

      # a new host key breaks known_hosts on every client and deploy
      environment.persistence."/persist".files = lib.concatMap (key: [
        key.path
        "${key.path}.pub"
      ]) config.services.openssh.hostKeys;

      # pin defaults that would lock us out of the VPS if they flipped
      services.openssh = {
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
}

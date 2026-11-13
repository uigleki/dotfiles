{ config, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.modules.server.imports = with nixos; [
    base
    hardening
    network
  ];

  nixos.modules.server.services = {
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
}

{
  flake.modules.nixos.server.services = {
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

{
  flake.modules.nixos.network = {
    # keep DHCP and NetworkManager from overriding dnscrypt-proxy in resolv.conf
    networking = {
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = "none";
    };

    services.dnscrypt-proxy = {
      enable = true;
      settings.require_dnssec = true;
    };
  };
}

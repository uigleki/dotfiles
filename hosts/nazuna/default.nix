{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ];
    loader.timeout = 0;
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 443;
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 ];
}

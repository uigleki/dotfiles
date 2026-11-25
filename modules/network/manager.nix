{
  nixos.modules.desktop =
    { config, ... }:
    {
      environment.persistence."/persist".directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
      ];

      networking = {
        # a NetworkManager hotspot serves DHCP and DNS to the devices that join it
        firewall = {
          allowedUDPPorts = [ 67 ];

          # only to NetworkManager's default shared subnet: libvirt's and podman's resolvers also listen on 53
          extraCommands = ''
            iptables -A nixos-fw -d 10.42.0.0/16 -p tcp --dport 53 -j nixos-fw-accept
            iptables -A nixos-fw -d 10.42.0.0/16 -p udp --dport 53 -j nixos-fw-accept
          '';
        };

        networkmanager = {
          enable = true;

          # a randomized MAC is still trackable while DHCP announces the hostname
          settings.connection = {
            "ipv4.dhcp-send-hostname" = false;
            "ipv6.dhcp-send-hostname" = false;
          };

          wifi.macAddress = "stable";
        };
      };

      users.users.${config.user.username}.extraGroups = [ "networkmanager" ];
    };
}

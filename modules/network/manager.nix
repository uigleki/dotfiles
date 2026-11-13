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
          allowedTCPPorts = [ 53 ];

          allowedUDPPorts = [
            53
            67
          ];
        };

        networkmanager.enable = true;
      };

      users.users.${config.user.username}.extraGroups = [ "networkmanager" ];
    };
}

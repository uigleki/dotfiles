{
  nixos.modules.desktop =
    { config, ... }:
    {
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

      users.users.${config.owner.username}.extraGroups = [ "networkmanager" ];
    };
}

{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      networking = {
        # required by WiFi hotspot
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

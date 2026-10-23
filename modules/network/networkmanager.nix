{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      networking = {
        networkmanager.enable = true;

        # required by WiFi hotspot
        firewall = {
          allowedTCPPorts = [ 53 ];

          allowedUDPPorts = [
            53
            67
          ];
        };
      };

      users.users.${config.owner.username}.extraGroups = [ "networkmanager" ];
    };
}

{
  nixos.modules = {
    network =
      { config, lib, ... }:
      {
        services.tailscale = {
          enable = true;
          disableUpstreamLogging = true;
          extraSetFlags = [ "--operator=${config.owner.username}" ];
          useRoutingFeatures = lib.mkDefault "client";
        };
      };

    server = {
      # tailscale's exit-node check wants both keys;
      # a drop-in, as udev applies only the first matching .link
      environment.etc."systemd/network/99-default.link.d/udp-gro-forwarding.conf".text = ''
        [Link]
        GenericReceiveOffloadList=false
        GenericReceiveOffloadUDPForwarding=true
      '';

      # "server" and "both" turn on IP forwarding; only the server advertises an exit node
      services.tailscale = {
        extraSetFlags = [ "--advertise-exit-node" ];
        useRoutingFeatures = "both";
      };
    };
  };

  homeManager.modules.desktop.services.tailscale-systray.enable = true;
}

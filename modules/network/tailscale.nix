{
  flake.modules = {
    nixos = {
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

      # "server" and "both" turn on IP forwarding; only the server advertises an exit node
      server.services.tailscale = {
        useRoutingFeatures = "both";
        extraSetFlags = [ "--advertise-exit-node" ];
      };
    };

    homeManager.desktop.services.tailscale-systray.enable = true;
  };
}

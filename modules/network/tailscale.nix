{
  flake.modules = {
    nixos = {
      network =
        { lib, ... }:
        {
          services.tailscale = {
            enable = true;
            disableUpstreamLogging = true;
            useRoutingFeatures = lib.mkDefault "client";
          };
        };

      # "server" and "both" turn on IP forwarding; only the server advertises an exit node
      server.services.tailscale.useRoutingFeatures = "both";
    };

    homeManager.desktop.services.tailscale-systray.enable = true;
  };
}

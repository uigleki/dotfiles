{ config, lib, ... }:
let
  cfg = config.myModules.network;
  bufferSize = 16 * 1024 * 1024; # 16 MiB in bytes
in
{
  options.myModules.network.enable = lib.mkEnableOption "network optimization and services" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = {
      # high-throughput, low-latency networking
      "net.core.default_qdisc" = "cake";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;

      # increased buffer sizes for high-throughput scenarios
      "net.core.rmem_max" = bufferSize;
      "net.core.wmem_max" = bufferSize;
    };

    networking = {
      firewall.enable = true; # pinned: a flip would expose every listening port
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = "none";
    };

    services = {
      chrony = {
        enable = true;
        enableNTS = true;
        servers = [ "time.cloudflare.com" ];
      };

      dnscrypt-proxy = {
        enable = true;
        settings.require_dnssec = true;
      };

      tailscale = {
        enable = true;
        disableUpstreamLogging = true;
        # "server" and "both" turn on IP forwarding; only the server advertises an exit node
        useRoutingFeatures = if config.myModules.server.enable then "both" else "client";
      };
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.myModules.network;
  bufferSize = 16 * 1024 * 1024; # 16MB in bytes
in
{
  options.myModules.network.enable = lib.mkEnableOption "network configuration" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    # TCP/BBR optimization for high-throughput, low-latency networking
    boot.kernel.sysctl = {
      "net.ipv4.tcp_fastopen" = 3; # enabled for both client and server
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";

      # increased buffer sizes for high-throughput scenarios
      "net.core.rmem_max" = bufferSize;
      "net.core.wmem_max" = bufferSize;
    };

    networking = {
      firewall.enable = true;
      # use dnscrypt-proxy as local DNS resolver
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
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
        settings = {
          require_dnssec = true;
          require_nofilter = true;
          require_nolog = true;
        };
      };

      tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
  };
}

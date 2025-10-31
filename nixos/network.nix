{ config, lib, ... }:
let
  cfg = config.myModules.network;
in
{
  options.myModules.network.enable = lib.mkEnableOption "Enable network configuration." // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
    };

    networking = {
      firewall.enable = true;
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = "none";
    };

    services = {
      dnscrypt-proxy = {
        enable = true;
        settings = {
          require_dnssec = true;
          require_nolog = true;
          require_nofilter = true;
        };
      };

      chrony = {
        enable = true;
        enableNTS = true;
        servers = [ "time.cloudflare.com" ];
      };

      tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
  };
}

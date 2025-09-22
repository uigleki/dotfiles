{ config, lib, ... }:
let
  cfg = config.myModules.network;
in
{
  options.myModules.network = {
    enable = lib.mkEnableOption "Enable network configuration." // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "tcp_bbr" ];
      kernel.sysctl = {
        "net.ipv4.ip_unprivileged_port_start" = 443;
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.rmem_max" = 2500000;
      };
    };

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 443 ];
      };

      nameservers = [
        "127.0.0.1"
        "::1"
      ];
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = "none";
    };

    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          PubkeyAuthentication = true;
        };
      };

      dnscrypt-proxy = {
        enable = true;
        settings = {
          require_dnssec = true;
          require_nolog = true;
          require_nofilter = true;
        };
      };

      tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
  };
}

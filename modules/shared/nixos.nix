{ pkgs, user, ... }:
{
  imports = [ ./nix.nix ];

  system.stateVersion = "24.05";

  nix.settings.auto-optimise-store = true;

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
    hostName = user.hostName;
    firewall.allowedTCPPorts = [ 443 ];
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  users.users.${user.name} = {
    isNormalUser = true;
    initialPassword = user.name;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = user.sshKeys;
  };

  security.sudo.wheelNeedsPassword = false;

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    dnscrypt-proxy2 = {
      enable = true;
      settings.require_dnssec = true;
    };
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    podman-compose
  ];
}

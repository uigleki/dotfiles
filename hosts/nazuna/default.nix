{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 443;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.rmem_max" = 2500000;
    };

    binfmt.emulatedSystems = [ "x86_64-linux" ];
  };

  networking = {
    useDHCP = true;
    firewall.allowedTCPPorts = [ 443 ];

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
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    dnscrypt-proxy = {
      enable = true;
      settings.require_dnssec = true;
    };
  };
}

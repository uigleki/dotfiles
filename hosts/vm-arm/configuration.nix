{
  modulesPath,
  pkgs,
  user,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ../shared.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

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

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    podman-compose
  ];

  users.users.${user.name} = {
    isNormalUser = true;
    initialPassword = user.name;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = user.sshKeys;
  };

  nix.settings.auto-optimise-store = true;

  networking = {
    hostName = user.hostName;

    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";

    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  system.stateVersion = "24.05";
}

{
  inputs,
  pkgs,
  user,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../home/nix.nix
    ./boot.nix
    ./disk-config.nix
    ./gui.nix
    ./network.nix
  ];

  system.stateVersion = user.stateVersion;
  nix = {
    channel.enable = false;
    settings.auto-optimise-store = true;
  };

  networking.hostName = user.hostName;

  users = {
    mutableUsers = false;
    users.${user.name} = {
      isNormalUser = true;
      initialPassword = user.name;
      extraGroups = [
        "wheel"
        "podman"
      ];
      openssh.authorizedKeys.keys = user.sshKeys;
      linger = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user.name}.imports = [ ../home ];
    extraSpecialArgs = { inherit inputs user; };
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
      autoPrune = {
        enable = true;
        flags = [
          "--all"
          "--filter=until=168h"
        ];
      };
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

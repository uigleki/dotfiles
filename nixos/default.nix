{
  inputs,
  pkgs,
  user,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./boot.nix
    ./disk-config.nix
    ./gui.nix
    ./network.nix
    ./nix.nix
    ./overlay.nix
    ./security.nix
    ./server.nix
    ./upgrade.nix
  ];

  system.stateVersion = user.stateVersion;

  nix = {
    channel.enable = false;
    settings.auto-optimise-store = true;
  };

  networking.hostName = user.hostName;

  users.users.${user.name} = {
    isNormalUser = true;
    uid = 1000;
    initialPassword = user.name;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = user.sshKeys;
    linger = true;
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

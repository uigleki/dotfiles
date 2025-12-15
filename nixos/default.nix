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
    ./security.nix
    ./server.nix
    ./upgrade.nix
  ];

  system.stateVersion = user.stateVersion;
  networking.hostName = user.hostName;

  nix = {
    channel.enable = false;
    settings.auto-optimise-store = true;
  };

  users.users.${user.name} = {
    inherit (user) uid;
    isNormalUser = true;
    initialPassword = user.name;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = user.sshKeys;
    linger = true; # allow user services to run without login session
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

  # Docker compatibility symlink for rootless podman
  systemd.tmpfiles.rules = [
    "L /var/run/docker.sock - - - - /run/user/${toString user.uid}/podman/podman.sock"
  ];

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

{
  inputs,
  pkgs,
  user,
  ...
}:
{
  imports = with inputs; [
    catppuccin.nixosModules.catppuccin
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    lanzaboote.nixosModules.lanzaboote
    nixos-wsl.nixosModules.default
    ./boot.nix
    ./disk-config.nix
    ./gui.nix
    ./network.nix
    ./nix.nix
    ./secure-boot.nix
    ./security.nix
    ./server.nix
    ./upgrade.nix
    ./wsl.nix
  ];

  system.stateVersion = user.stateVersion;
  networking.hostName = user.hostName;

  nix = {
    channel.enable = false;
    settings.auto-optimise-store = true;
  };

  programs.nix-ld.enable = true;

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

  systemd.tmpfiles.rules = [
    # Docker compatibility symlink for rootless podman
    "L /var/run/docker.sock - - - - /run/user/${toString user.uid}/podman/podman.sock"
    # Remove legacy channel profiles (flakes-only configuration)
    "R /nix/var/nix/profiles/per-user/root/channels - - - -"
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

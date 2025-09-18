{ pkgs, user, ... }:
{
  imports = [
    ../home/nix.nix
    ./boot.nix
    ./disk-config.nix
    ./gui.nix
    ./network.nix
  ];

  system.stateVersion = "24.05";

  nix.settings.auto-optimise-store = true;

  networking.hostName = user.hostName;

  users.users.${user.name} = {
    isNormalUser = true;
    initialPassword = user.name;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = user.sshKeys;
  };

  security.sudo.wheelNeedsPassword = false;

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

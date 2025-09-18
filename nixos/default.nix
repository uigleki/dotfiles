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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user.name}.imports = [ ../home ];
    extraSpecialArgs = { inherit user; };
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

{
  pkgs,
  user,
  ...
}:
{
  imports = [
    ../shared/nix.nix
    ./boot.nix
    ./desktop.nix
    ./disk.nix
    ./network.nix
    ./secure-boot.nix
    ./security.nix
    ./server.nix
    ./upgrade.nix
    ./wsl.nix
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 180; # Aggressively use ZRAM
    "vm.watermark_boost_factor" = 0; # Prevent latency spikes
    "vm.watermark_scale_factor" = 125; # Reclaim memory earlier
    "vm.page-cluster" = 0; # Disable read-ahead
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    podman-compose
    vim
  ];

  networking.hostName = user.hostName;

  nix = {
    channel.enable = false;
    settings.auto-optimise-store = true;
  };

  programs.nix-ld.enable = true;

  security.sudo.wheelNeedsPassword = false;

  systemd.tmpfiles.rules = [
    # Docker compatibility symlink for rootless podman
    "L /var/run/docker.sock - - - - /run/user/${toString user.uid}/podman/podman.sock"
    # Remove legacy channel profiles (flakes-only configuration)
    "R /nix/var/nix/profiles/per-user/root/channels - - - -"
  ];

  users.users.${user.name} = {
    inherit (user) uid;
    isNormalUser = true;
    initialPassword = user.name;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = user.sshKeys;
    linger = true; # allow user services to run without login session
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  zramSwap.enable = true;

  system.stateVersion = user.stateVersion;
}

{
  lib,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ../shared/nix.nix
    ./desktop.nix
    ./disk.nix
    ./network.nix
    ./secure-boot.nix
    ./security.nix
    ./server.nix
    ./upgrade.nix
    ./wsl.nix
  ];

  boot = {
    kernel.sysctl = {
      # recommended for zramSwap
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkDefault true;
        configurationLimit = 5; # prevent boot partition running out of space
      };
    };
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

  services.earlyoom = {
    enable = true;
    enableNotifications = true;

    # free swap is not a headroom signal on zram
    freeSwapThreshold = 100;
    freeSwapKillThreshold = 100;

    extraArgs = [
      "-M" # cap the 10% headroom on large-memory hosts
      (toString (1024 * 1024)) # 1 GiB in KiB
    ];
  };

  systemd = {
    oomd.enable = false; # does nothing without a ManagedOOM slice opt-in
    tmpfiles.rules = [
      # docker compatibility symlink for rootless podman
      "L /var/run/docker.sock - - - - /run/user/${toString user.uid}/podman/podman.sock"
      # remove legacy channel profiles (flakes-only configuration)
      "R /nix/var/nix/profiles/per-user/root/channels - - - -"
    ];
  };

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

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    memoryMax = 8 * 1024 * 1024 * 1024; # 8 GiB in bytes
  };

  system.stateVersion = user.stateVersion;
}

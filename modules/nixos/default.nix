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
      "vm.page-cluster" = 0;
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
    };

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = lib.mkDefault true;
        configurationLimit = 5; # prevent boot partition running out of space
      };
    };
  };

  documentation.doc.enable = false;

  environment.systemPackages = with pkgs; [
    git
    podman-compose
    vim

    # already in the closure, just not on PATH
    file
    jq
    python3
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
      "L /run/docker.sock - - - - /run/user/${toString user.uid}/podman/podman.sock"
      # remove legacy channel profiles (flakes-only configuration)
      "R /nix/var/nix/profiles/per-user/root/channels* - - - -"
    ];
  };

  users.users.${user.name} = {
    inherit (user) uid;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = user.name;
    linger = true; # allow user services to run without login session
    openssh.authorizedKeys.keys = user.sshKeys;
  };

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
    };
  };

  zramSwap = {
    enable = true;
    memoryMax = 8 * 1024 * 1024 * 1024; # 8 GiB in bytes
    memoryPercent = 100;
  };

  system.stateVersion = user.stateVersion;
}

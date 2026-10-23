{
  flake.modules.nixos.base = {
    boot.kernel.sysctl = {
      # recommended for zramSwap
      "vm.page-cluster" = 0;
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
    };

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

    systemd.oomd.enable = false; # does nothing without a ManagedOOM slice opt-in

    zramSwap = {
      enable = true;
      memoryMax = 8 * 1024 * 1024 * 1024; # 8 GiB in bytes
      memoryPercent = 100;
    };
  };
}

{
  nixos.modules.btrfs =
    { pkgs, ... }:
    {
      environment = {
        persistence."/persist".directories = [ "/var/lib/btrfs" ]; # scrub progress, to resume and report
        systemPackages = [ pkgs.e2fsprogs ]; # chattr/lsattr, only auto-added for ext filesystems
      };

      services.btrfs.autoScrub.enable = true;

      systemd = {
        services.btrfs-stats = {
          serviceConfig.Type = "oneshot";
          description = "Check btrfs device error counters";

          path = with pkgs; [
            btrfs-progs
            dbus
          ];

          # systembus-notify relays this signal as a desktop popup
          script = ''
            if ! btrfs device stats --check /; then
              dbus-send --system / net.nuetzlich.SystemNotifications.Notify \
                'string:btrfs' 'string:Device errors on /, see: btrfs device stats /'
              exit 1
            fi
          '';

          startAt = "daily";
        };

        timers.btrfs-stats.timerConfig.Persistent = true;
      };
    };
}

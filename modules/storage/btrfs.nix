{
  flake.modules.nixos.btrfs =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.e2fsprogs ]; # chattr/lsattr, only auto-added for ext filesystems

      services.btrfs.autoScrub.enable = true;

      systemd = {
        services.btrfs-stats = {
          description = "Check btrfs device error counters";
          path = with pkgs; [
            btrfs-progs
            dbus
          ];
          serviceConfig.Type = "oneshot";

          # systembus-notify relays this signal as a desktop popup
          script = ''
            if ! btrfs device stats --check /; then
              dbus-send --system / net.nuetzlich.SystemNotifications.Notify \
                'string:btrfs' 'string:Device errors on /, see: btrfs device stats /'
              exit 1
            fi
          '';
        };

        timers.btrfs-stats = {
          wantedBy = [ "timers.target" ];

          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
        };
      };
    };
}

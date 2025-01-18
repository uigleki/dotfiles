{ pkgs, ... }: {
  systemd.user = {
    services.nix-cleanup = {
      Unit.Description = "Monthly Nix store cleanup";
      Service = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d";
        IOSchedulingClass = "idle";
        CPUSchedulingPolicy = "idle";
      };
    };

    timers.nix-cleanup = {
      Unit.Description = "Monthly Nix store cleanup";
      Timer = {
        OnCalendar = "monthly";
        AccuracySec = "1h";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

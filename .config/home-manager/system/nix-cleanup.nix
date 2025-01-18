{ pkgs, ... }: {
  systemd.user = {
    services.nix-cleanup = {
      Unit.Description = "Monthly Nix store cleanup";
      Service = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d";
      };
    };

    timers.nix-cleanup = {
      Unit.Description = "Monthly Nix store cleanup";
      Timer = {
        OnCalendar = "monthly";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

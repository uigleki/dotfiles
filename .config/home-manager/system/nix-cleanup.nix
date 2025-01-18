{ pkgs, ... }: {
  programs.systemd.user = {
    services.nix-cleanup = {
      Unit = { Description = "Clean up old Nix store paths"; };
      Service = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d";
      };
    };

    timers.nix-cleanup = {
      Unit = { Description = "Monthly Nix store cleanup"; };
      timerConfig = {
        OnCalendar = "monthly";
        Persistent = true;
      };
      Install = { WantedBy = [ "timers.target" ]; };
    };
  };
}

{ pkgs, ... }:
let
  name = "nix-cleanup";
  description = "Monthly Nix store cleanup";
in {
  systemd.user = {
    services.${name} = {
      Unit.Description = description;
      Service = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d";
      };
    };

    timers.${name} = {
      Unit.Description = description;
      Timer = {
        OnCalendar = "monthly";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

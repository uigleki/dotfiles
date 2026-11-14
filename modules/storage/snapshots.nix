{ config, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.modules.snapshots = {
    # btrbk reaches system state only through impermanence's binds into /persist
    imports = [ nixos.impermanence ];

    services.btrbk.instances.btrbk = {
      onCalendar = "hourly";

      settings = {
        snapshot_dir = "/snapshots";
        snapshot_preserve = "14d";
        snapshot_preserve_min = "2d";

        subvolume = {
          "/home" = { };
          "/persist" = { };
        };
      };
    };
  };
}

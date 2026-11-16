{ config, inputs, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.modules.secure-boot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        nixos.systemd-boot
      ];

      boot = {
        lanzaboote = {
          enable = true;

          autoEnrollKeys = {
            enable = true;
            autoReboot = true;
          };

          autoGenerateKeys.enable = true;
          pkiBundle = "/var/lib/sbctl";
        };

        # lanzaboote replaces systemd-boot's installer but reads its settings
        loader.systemd-boot.enable = lib.mkForce false;
      };

      environment = {
        # a missing key directory makes lanzaboote generate keys the firmware has never enrolled
        persistence."/persist".directories = [ config.boot.lanzaboote.pkiBundle ];
        systemPackages = [ pkgs.sbctl ];
      };
    };
}

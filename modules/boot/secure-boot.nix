{ inputs, ... }:
{
  nixos.modules.secure-boot =
    { config, pkgs, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot = {
        lanzaboote = {
          enable = true;

          autoEnrollKeys = {
            enable = true;
            autoReboot = true;
          };

          autoGenerateKeys.enable = true;
          configurationLimit = 5; # prevent boot partition running out of space
          pkiBundle = "/var/lib/sbctl";
        };

        loader.efi.canTouchEfiVariables = true;
      };

      environment = {
        # a missing key directory makes lanzaboote generate keys the firmware has never enrolled
        persistence."/persist".directories = [ config.boot.lanzaboote.pkiBundle ];
        systemPackages = [ pkgs.sbctl ];
      };
    };
}

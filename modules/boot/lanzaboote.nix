{ inputs, ... }:
{
  flake.modules.nixos.lanzaboote =
    { pkgs, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot = {
        loader.efi.canTouchEfiVariables = true;

        lanzaboote = {
          enable = true;
          autoGenerateKeys.enable = true;
          configurationLimit = 5; # prevent boot partition running out of space
          pkiBundle = "/var/lib/sbctl";

          autoEnrollKeys = {
            enable = true;
            autoReboot = true;
          };
        };
      };

      environment.systemPackages = [ pkgs.sbctl ];
    };
}

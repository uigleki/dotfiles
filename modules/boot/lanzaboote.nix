{ inputs, ... }:
{
  flake.modules.nixos.lanzaboote =
    { pkgs, ... }:
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

      environment.systemPackages = [ pkgs.sbctl ];
    };
}

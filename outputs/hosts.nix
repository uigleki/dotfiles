{ inputs, lib, ... }:
let
  baseUser = {
    name = "u";
    system = "x86_64-linux";

    gitName = "Ray";
    gitEmail = "30580339+uigleki@users.noreply.github.com";
    flake = "$HOME/.config/dotfiles";
    syncDir = "$HOME/sync/a";

    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];

    # user ID - changing this would break ownership of all existing files
    uid = 1000;
    # do not change on upgrade
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "26.05";
  };

  nixosHosts = {
    akira = { };

    inori = {
      name = "nixos"; # keep WSL default to avoid home directory migration
    };

    nazuna = {
      system = "aarch64-linux";
    };

    # future host names: kurisu, miyabi, hitagi, yuna
  };
in
{
  flake = {
    nixosConfigurations = lib.mapAttrs (
      hostName: extra:
      let
        user = baseUser // { inherit hostName; } // extra;
      in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs user; };

        modules = [
          ../modules/nixos
          ../hosts/${hostName}
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs.hostPlatform = user.system;

            home-manager = {
              extraSpecialArgs = { inherit inputs user; };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user.name}.imports = [ ../modules/home ];
            };
          }
        ];
      }
    ) nixosHosts;
  };
}

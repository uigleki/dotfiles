{ inputs, lib, ... }:
let
  inherit (import ../lib { inherit inputs; }) mkHome mkSystem;

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
    stateVersion = "25.05";
  };

  homeHosts = {
    kurisu = { };
  };

  nixosHosts = {
    nazuna = {
      system = "aarch64-linux";
    };

    akira = { };

    inori = {
      name = "nixos"; # keep WSL default to avoid home directory migration
    };

    # future host names: miyabi, hitagi
  };
in
{
  flake = {
    homeConfigurations = lib.mapAttrs (
      hostName: extra:
      mkHome {
        user = baseUser // { inherit hostName; } // extra;
      }
    ) homeHosts;

    nixosConfigurations = lib.mapAttrs (
      hostName: extra:
      mkSystem {
        user = baseUser // { inherit hostName; } // extra;
        extraModules = [ ../hosts/${hostName} ];
      }
    ) nixosHosts;
  };
}

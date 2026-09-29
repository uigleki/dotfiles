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
    stateVersion = "26.05";
  };

  homeHosts = {
    kurisu = { };
  };

  nixosHosts = {
    akira = { };

    inori = {
      name = "nixos"; # keep WSL default to avoid home directory migration
    };

    nazuna = {
      system = "aarch64-linux";
    };

    # future host names: miyabi, hitagi
  };
in
{
  flake = {
    # nh and home-manager look up <username>@<hostname>
    homeConfigurations = lib.mapAttrs' (
      hostName: extra:
      let
        user = baseUser // { inherit hostName; } // extra;
      in
      lib.nameValuePair "${user.name}@${hostName}" (mkHome {
        inherit user;
      })
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

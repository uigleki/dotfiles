{ inputs, ... }:
let
  inherit (inputs) nixpkgs home-manager;

  baseUser = {
    name = "u";
    hostName = "nixos";
    system = "x86_64-linux";

    gitName = "Ray";
    gitEmail = "30580339+uigleki@users.noreply.github.com";
    flake = "$HOME/.config/dotfiles";

    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];

    # System constants
    # User ID - changing this would break ownership of all existing files
    uid = 1000;
    # Do not change on upgrade
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };

  nazuna = baseUser // {
    hostName = "nazuna";
    system = "aarch64-linux";
  };

  akira = baseUser // {
    name = "nixos";
  };

  kurisu = baseUser // {
    hostName = "kurisu";
  };

  mayuri = baseUser // {
    hostName = "mayuri";
  };

  mkHomeConfig =
    {
      user,
      extraModules ? [ ],
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${user.system};
      modules = [ ../home ] ++ extraModules;
      extraSpecialArgs = { inherit inputs user; };
    };

  mkNixOSConfig =
    {
      user,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit (user) system;
      modules = [ ../nixos ] ++ extraModules;
      specialArgs = { inherit inputs user; };
    };
in
{
  nixosConfigurations = {
    "${nazuna.hostName}" = mkNixOSConfig {
      user = nazuna;
      extraModules = [ ./nazuna ];
    };

    "${akira.hostName}" = mkNixOSConfig {
      user = akira;
      extraModules = [ ./akira ];
    };

    "${mayuri.hostName}" = mkNixOSConfig {
      user = mayuri;
      extraModules = [ ./mayuri ];
    };
  };

  homeConfigurations = {
    "${kurisu.hostName}" = mkHomeConfig {
      user = kurisu;
      extraModules = [ ./kurisu ];
    };
  };
}

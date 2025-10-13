{ inputs }:
let
  inherit (inputs) nixpkgs home-manager;

  baseUser = {
    name = "u";
    system = "x86_64-linux";
    gitName = "Ray";
    gitEmail = "rraayy246@gmail.com";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];
    flake = "$HOME/.config/home-manager";
    stateVersion = "25.11";
  };

  nazuna = baseUser // {
    hostName = "nazuna";
    system = "aarch64-linux";
  };

  akira = baseUser // {
    name = "nixos";
    hostName = "nixos";
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

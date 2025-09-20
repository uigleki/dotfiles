{ inputs }:
let
  inherit (inputs) nixpkgs home-manager;

  user = {
    name = "u";
    hostName = "nazuna";
    gitName = "Ray";
    gitEmail = "rraayy246@gmail.com";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];
    flake = "$HOME/.config/home-manager";
    stateVersion = "25.11";
  };

  akira = user // {
    name = "nixos";
    hostName = "nixos";
  };

  kurisu = user // {
    name = "win";
    hostName = "kurisu";
  };

  mayuri = user // {
    hostName = "mayuri";
  };

  mkHomeConfig =
    {
      system,
      user,
      extraModules ? [ ],
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ../home ] ++ extraModules;
      extraSpecialArgs = { inherit inputs user; };
    };

  mkNixOSConfig =
    {
      system,
      user,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ../nixos ] ++ extraModules;
      specialArgs = { inherit inputs user; };
    };
in
{
  nixosConfigurations = {
    "${user.hostName}" = mkNixOSConfig {
      system = "aarch64-linux";
      user = user;
      extraModules = [ ./nazuna ];
    };

    "${akira.hostName}" = mkNixOSConfig {
      system = "x86_64-linux";
      user = akira;
      extraModules = [ ./akira ];
    };

    "${mayuri.hostName}" = mkNixOSConfig {
      system = "x86_64-linux";
      user = mayuri;
      extraModules = [ ./mayuri ];
    };
  };

  homeConfigurations = {
    "${kurisu.hostName}" = mkHomeConfig {
      system = "x86_64-linux";
      user = kurisu;
      extraModules = [ ./kurisu ];
    };
  };
}

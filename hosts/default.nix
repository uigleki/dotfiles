{ inputs }:
let
  inherit (inputs)
    nixpkgs
    home-manager
    disko
    nixos-wsl
    ;

  user = {
    name = "u";
    hostName = "nazuna";
    gitName = "Ray";
    gitEmail = "rraayy246@gmail.com";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];
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

  coreModules = [
    ../home/core.nix
  ];

  mkHomeConfig =
    {
      system,
      user,
      extraModules ? [ ],
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules =
        coreModules
        ++ extraModules
        ++ [
          ../home
          {
            home = {
              username = user.name;
              homeDirectory = "/home/${user.name}";
            };
          }
        ];
      extraSpecialArgs = {
        inherit user;
        isNixOS = false;
      };
    };

  mkNixOSConfig =
    {
      system,
      user,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        ../nixos
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user.name} = {
              imports = coreModules;
            };
            extraSpecialArgs = {
              inherit user;
              isNixOS = true;
            };
          };
        }
      ]
      ++ extraModules;
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
      extraModules = [
        nixos-wsl.nixosModules.default
        {
          wsl.enable = true;
          programs.nix-ld.enable = true;
        }
        ./akira
      ];
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

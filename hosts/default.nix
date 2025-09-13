{ inputs }:
let
  inherit (inputs) nixpkgs home-manager disko;

  user = {
    name = "u";
    hostName = "nazuna";
    userName = "Ray";
    userEmail = "rraayy246@gmail.com";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];
  };

  akira = user // {
    name = "win";
    hostName = "akira";
  };

  coreModules = [
    ../modules/core.nix
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
          ../modules/shared/home.nix
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
      extraHomeModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        ../modules/shared/nixos.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user.name} = {
              imports = coreModules ++ extraHomeModules;
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
      extraModules = [ ./nazuna/configuration.nix ];
    };
  };

  homeConfigurations = {
    "${akira.hostName}" = mkHomeConfig {
      system = "x86_64-linux";
      user = akira;
      extraModules = [ ./akira/home.nix ];
    };
  };
}

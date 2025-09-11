{ inputs }:
let
  inherit (inputs) nixpkgs home-manager disko;

  user = {
    name = "u";
    hostName = "vm-arm";
    email = "rraayy246@gmail.com";
    fullName = "Ray";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];
  };

  wslUser = user // {
    name = "win";
    hostName = "win";
  };

  coreModules = [
    ../modules/core.nix
  ];
in
{
  homeConfigurations = {
    "${wslUser.hostName}" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = coreModules ++ [
        ./hm-amd/home.nix
        {
          home = {
            username = wslUser.name;
            homeDirectory = "/home/${wslUser.name}";
          };
          nixpkgs.config.allowUnfree = true;
        }
      ];
      extraSpecialArgs = {
        user = wslUser;
        isNixOS = false;
      };
    };
  };

  nixosConfigurations = {
    vm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        disko.nixosModules.disko
        ./vm-arm/disk-config.nix
        ./vm-arm/configuration.nix

        home-manager.nixosModules.home-manager
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
      ];
      specialArgs = { inherit inputs user; };
    };
  };
}

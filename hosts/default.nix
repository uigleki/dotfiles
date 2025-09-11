{ inputs }:
let
  inherit (inputs) nixpkgs home-manager disko;

  user = {
    name = "u";
    email = "rraayy246@gmail.com";
    fullName = "Ray";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];
  };

  wslUser = user // {
    name = "win";
  };

  coreModules = [
    ../modules/core.nix
  ];
in
{
  homeConfigurations =
    let
      hostname = "win";
    in
    {
      "${hostname}" = home-manager.lib.homeManagerConfiguration {
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
          inherit hostname;
          isNixOS = false;
        };
      };
    };

  nixosConfigurations =
    let
      hostname = "vm-arm";
    in
    {
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
                inherit user hostname;
                isNixOS = true;
              };
            };
          }
        ]
        ++ nixpkgs.lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;
        specialArgs = { inherit inputs user hostname; };
      };
    };
}

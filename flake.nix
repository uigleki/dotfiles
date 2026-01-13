{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      formatter = eachSystem (system: (pkgsFor system).nixfmt-rfc-style);

      checks = eachSystem (system: {
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            convco.enable = true;
            deadnix.enable = true;
            nil.enable = true;
            nixfmt-rfc-style.enable = true;
            statix.enable = true;
          };
          package = (pkgsFor system).prek;
        };
      });

      devShells = eachSystem (system: {
        default =
          let
            check = self.checks.${system}.pre-commit-check;
          in
          (pkgsFor system).mkShellNoCC {
            inherit (check) shellHook;
            packages = check.enabledPackages;
          };
      });
    }
    // import ./hosts { inherit inputs; };
}

{
  description = "Personal dotfiles with multi-host support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      home-manager,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixfmt
            shellcheck
            shfmt
          ];
          shellHook = ''echo "🚀 Development environment activated"'';
        };
      }
    )
    // {
      homeConfigurations =
        let
          inherit (import ./.local) system username;
          pkgs = nixpkgs.legacyPackages.${system};

          optionalTOML =
            path:
            nixpkgs.lib.optionalAttrs (builtins.pathExists path) (builtins.fromTOML (builtins.readFile path));
          userConfig = {
            inherit username;
          }
          // optionalTOML ./config.toml;
        in
        {
          ${username} = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./profiles/cli.nix
              ./hosts/wsl/home.nix
            ];
            extraSpecialArgs = { inherit userConfig; };
          };
        };
    };
}

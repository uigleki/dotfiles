{ inputs, ... }:
{
  flake.modules.homeManager.base = {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];

    programs = {
      nix-index-database.comma.enable = true; # run uninstalled commands: , <cmd>
      nix-index.enable = true;
    };
  };
}

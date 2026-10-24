{ inputs, ... }:
{
  # the channel tarball ships programs.sqlite, which turns this on; nix-index answers instead
  flake.modules.nixos.base.programs.command-not-found.enable = false;

  flake.modules.homeManager.base = {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];

    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = true; # run uninstalled commands: , <cmd>
    };
  };
}

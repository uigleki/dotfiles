{ inputs, ... }:
{
  nixos.modules.base = {
    environment.persistence."/persist".directories = [ "/root/.local/state/comma" ]; # the package picked when several provide a command

    # the channel tarball ships programs.sqlite, which turns this on; nix-index answers instead
    programs.command-not-found.enable = false;
  };

  homeManager.modules.base = {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];

    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = true; # run uninstalled commands: , <cmd>
    };
  };
}

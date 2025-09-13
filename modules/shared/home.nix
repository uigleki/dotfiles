{ pkgs, ... }:
{
  imports = [ ./nix.nix ];

  nix.package = pkgs.nix;
}

{ lib, ... }:
let
  inherit (lib) mkOption types;
  str = types.singleLineStr;
in
{
  options.owner = {
    flakeDir = mkOption { type = str; }; # relative to home
    gitEmail = mkOption { type = str; };
    gitName = mkOption { type = str; };
    sshKeys = mkOption { type = types.listOf str; };
    stateVersion = mkOption { type = str; };
    syncDir = mkOption { type = str; }; # relative to home
    timeZone = mkOption { type = str; };
    uid = mkOption { type = types.ints.unsigned; };
    username = mkOption { type = str; };
  };

  config.owner = {
    # retuned often: bumped with the release inputs in flake.nix,
    # as no host runs services whose data depends on it
    stateVersion = "26.05";

    flakeDir = ".config/dotfiles";
    gitName = "Ray";
    gitEmail = "30580339+uigleki@users.noreply.github.com";

    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];

    syncDir = "sync/a";

    # also the clock for every timer, e.g. auto-upgrade at 04:40
    timeZone = "Asia/Shanghai";

    # changing this would break ownership of all existing files
    uid = 1000;

    username = "u";
  };
}

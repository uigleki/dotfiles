{ lib, ... }:
let
  inherit (lib) mkOption types;
  str = types.singleLineStr;
in
{
  options.owner = {
    username = mkOption { type = str; };
    uid = mkOption { type = types.ints.unsigned; };
    gitName = mkOption { type = str; };
    gitEmail = mkOption { type = str; };
    sshKeys = mkOption { type = types.listOf str; };
    flakeDir = mkOption { type = str; }; # relative to home
    syncDir = mkOption { type = str; }; # relative to home
    timeZone = mkOption { type = str; };
    stateVersion = mkOption { type = str; };
  };

  config.owner = {
    username = "u";
    # changing this would break ownership of all existing files
    uid = 1000;

    gitName = "Ray";
    gitEmail = "30580339+uigleki@users.noreply.github.com";

    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];

    flakeDir = ".config/dotfiles";
    syncDir = "sync/a";

    # also the clock for every timer, e.g. auto-upgrade at 04:40
    timeZone = "Asia/Shanghai";

    # Bumped with every NixOS release: no host runs services whose data depends on it.
    stateVersion = "26.05";
  };
}

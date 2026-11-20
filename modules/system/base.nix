{ config, ... }:
let
  inherit (config) user;
in
{
  nixos.modules.base =
    { pkgs, ... }:
    {
      documentation.doc.enable = false;

      environment.systemPackages = with pkgs; [
        # already in the closure, just not on PATH
        file
        jq
        python3
      ];

      programs = {
        git.enable = true;
        nix-ld.enable = true;
      };

      system.stateVersion = user.stateVersion;
      time.timeZone = user.timeZone;
    };
}

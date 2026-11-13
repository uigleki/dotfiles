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
        git
        vim

        # already in the closure, just not on PATH
        file
        jq
        python3
      ];

      programs.nix-ld.enable = true;
      system.stateVersion = user.stateVersion;
      time.timeZone = user.timeZone;
    };
}

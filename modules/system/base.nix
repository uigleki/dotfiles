{ config, ... }:
let
  inherit (config) owner;
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
      system.stateVersion = owner.stateVersion;
      time.timeZone = owner.timeZone;
    };
}

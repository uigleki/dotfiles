{ config, ... }:
let
  inherit (config) owner;
in
{
  homeManager.modules.desktop =
    { config, pkgs, ... }:
    {
      dconf.settings."com/github/neithern/g4music".music-dir =
        "file://${config.home.homeDirectory}/${owner.syncDir}/music";

      home.packages = [ pkgs.gapless ];
    };
}

{ config, ... }:
let
  inherit (config) user;
in
{
  homeManager.modules.desktop =
    { config, pkgs, ... }:
    {
      dconf.settings."com/github/neithern/g4music".music-dir =
        "file://${config.home.homeDirectory}/${user.syncDir}/music";

      home.packages = [ pkgs.gapless ];
    };
}

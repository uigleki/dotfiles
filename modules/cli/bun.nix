{
  flake.modules.homeManager.base =
    { config, lib, ... }:
    let
      bun = config.programs.bun.package;
    in
    {
      programs.bun.enable = true;

      home = {
        file = {
          ".local/bin/node".source = lib.getExe bun;
          ".local/bin/npx".source = lib.getExe' bun "bunx";
        };

        sessionPath = [ "${config.home.homeDirectory}/.bun/bin" ];
      };
    };
}

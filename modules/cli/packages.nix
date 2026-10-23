{
  flake.modules.homeManager.base =
    { config, pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          nix-tree

          # used by coding agents
          bc
          imagemagick
          lsof
          poppler-utils
          psmisc
          python3Packages.trafilatura
          tree
          unzip
        ];

        sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
        sessionVariables.COLORTERM = "truecolor";
      };

      programs = {
        bat.enable = true;
        bottom.enable = true;

        eza = {
          enable = true;

          extraOptions = [
            "--group-directories-first"
            "--time-style=iso"
          ];
        };

        fd.enable = true;

        gh = {
          enable = true;
          settings.telemetry = "disabled";
        };

        ripgrep = {
          enable = true;
          arguments = [ "--smart-case" ];
        };

        starship.enable = true;
        uv.enable = true;

        yazi = {
          enable = true;
          shellWrapperName = "d";
        };

        zoxide = {
          enable = true;
          options = [ "--cmd j" ];
        };
      };
    };
}

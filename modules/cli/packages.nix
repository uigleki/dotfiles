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

        sessionVariables = {
          COLORTERM = "truecolor";
        };
      };

      programs = {
        bat.enable = true;
        bottom.enable = true;
        fd.enable = true;
        starship.enable = true;
        uv.enable = true;

        eza = {
          enable = true;

          extraOptions = [
            "--group-directories-first"
            "--time-style=iso"
          ];
        };

        gh = {
          enable = true;
          settings.telemetry = "disabled";
        };

        ripgrep = {
          enable = true;
          arguments = [ "--smart-case" ];
        };

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

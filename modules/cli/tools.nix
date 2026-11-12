{
  homeManager.modules.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nix-tree
        nodejs-slim
        pnpm
      ];

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

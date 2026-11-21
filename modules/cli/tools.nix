{
  homeManager.modules.base =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          nodejs-slim
          pnpm
        ];

        persistence = {
          "/cache".directories = [
            ".local/share/pnpm"
            ".local/share/uv"
            ".local/state/pnpm"
          ];

          "/persist".directories = [
            ".config/gh" # the login token
            ".local/share/zoxide"
          ];
        };
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

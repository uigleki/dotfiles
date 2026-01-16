{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.dev;
  isDesktop = config.myModules.desktop.enable;
  pnpmHome = "${config.xdg.dataHome}/pnpm";
in
{
  options.myModules.dev.enable = lib.mkEnableOption "development environment" // {
    default = true;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = with pkgs; [
          nodejs_24
          pnpm
          uv
        ];

        sessionPath = [
          "$HOME/.local/bin"
          pnpmHome
        ];

        sessionVariables = {
          PNPM_HOME = pnpmHome;
        };
      };
    })
    (lib.mkIf (cfg.enable && isDesktop) {
      home.packages = with pkgs; [ unstable.antigravity ]; # Google's VSCode fork

      programs = {
        vscode.enable = true;

        fish.functions.src = ''
          argparse 'e/exclude=+' -- $argv
          or return

          set -l dirs $argv
          test -z "$dirs" && set dirs .

          set -l exclude '^LICENSE|\.lock$|\.sum$|package-lock|pnpm-lock'
          for e in $_flag_exclude
            set exclude "$exclude|$e"
          end

          begin
            for dir in $dirs
              set -l name (basename (realpath $dir))
              echo "<project name=\"$name\">"
              for f in (git -C $dir ls-files | rg -v $exclude)
                echo "<file path=\"$f\">"
                bat -pp "$dir/$f"
                echo "</file>"
              end
              echo "</project>"
            end
          end | wl-copy
        '';
      };
    })
  ];
}

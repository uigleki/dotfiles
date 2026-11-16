{
  homeManager.modules.base =
    { config, lib, ... }:
    {
      options.updateCommands = lib.mkOption { type = with lib.types; listOf str; };

      config = {
        updateCommands = lib.mkBefore [ "nh os switch --update" ];

        home = {
          persistence = {
            "/persist".directories = [
              ".config/fish" # universal variables
              ".local/share/fish"
            ];

            "/cache".directories = [ ".local/bin" ]; # links into installs that are themselves in /cache
          };

          sessionPath = [ config.xdg.binHome ];
          sessionVariables.COLORTERM = "truecolor"; # SSH drops it and Windows Terminal never sets it
        };

        programs = {
          bash = {
            enable = true;

            # before fzf's init at 200, which the exec would discard
            initExtra = lib.mkOrder 150 ''
              # Bash stays the login shell so that $SHELL stays POSIX:
              # fish rejects the sh syntax that programs pass to $SHELL -c or send over SSH.
              if [[ $(< /proc/$PPID/comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] 2> /dev/null; then
                shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
                exec ${lib.getExe config.programs.fish.package} $LOGIN_OPTION
              fi
            '';
          };

          fish = {
            enable = true;
            interactiveShellInit = "set fish_greeting";

            shellAbbrs = {
              c = "claude";
              co = "codex";
              f = "$EDITOR";

              G = {
                expansion = "| rg";
                position = "anywhere";
              };

              gc = "git clone --depth=1";
              gl = "git pull";
              h = "herdr";
              k = "btm";
              l = "eza -la";
              r = "rsync -rthP";
              u = "nh os switch";
              uu = lib.concatStringsSep " && " config.updateCommands;
            };
          };

          starship.enable = true;
        };
      };
    };
}

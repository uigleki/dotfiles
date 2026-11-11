{
  flake.modules.homeManager.base =
    { config, lib, ... }:
    {
      options.updateCommands = lib.mkOption { type = with lib.types; listOf str; };

      config = {
        updateCommands = lib.mkBefore [ "nh os switch --update" ];

        programs = {
          bash = {
            enable = true;

            # before fzf's init at 200, which the exec would discard
            initExtra = lib.mkOrder 150 ''
              # Launch fish from bash to preserve login shell profile sourcing.
              # Setting users.users.*.shell = fish directly would skip /etc/profile.
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
        };
      };
    };
}

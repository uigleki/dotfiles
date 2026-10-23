{
  config,
  lib,
  pkgs,
  ...
}:
let
  secretsFile = "$HOME/.config/secrets.sh";
in
{
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        # not using sops-nix etc: builds should succeed without keys
        [ -f "${secretsFile}" ] && source "${secretsFile}"

        # Launch fish from bash to preserve login shell profile sourcing.
        # Setting users.users.*.shell = fish directly would skip /etc/profile.
        if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
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
        gc = "git clone --depth=1";
        gl = "git pull";
        h = "herdr";
        k = "btm";
        l = "eza -la";
        r = "rsync -rthP";
        u = "nh os switch";
        uu = "nh os switch --update";

        G = {
          position = "anywhere";
          expansion = "| rg";
        };
      };
    };
  };
}

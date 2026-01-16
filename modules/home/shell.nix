{
  pkgs,
  user,
  osConfig ? null,
  ...
}:
let
  secretsFile = "$HOME/.config/secrets.sh";
  rebuildCmd = if osConfig == null then "nh home switch" else "nh os switch";
in
{
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        # Load local secrets if exists
        [ -f "${secretsFile}" ] && source "${secretsFile}"

        # Launch fish from bash to preserve login shell profile sourcing.
        # Setting users.users.*.shell = fish directly would skip /etc/profile.
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    fish = {
      enable = true;
      interactiveShellInit = "set fish_greeting";

      shellAbbrs = {
        d = "yazi";
        f = "$EDITOR";
        g = "lazygit";
        gc = "git clone";
        gl = "git pull";
        k = "btm";
        l = "eza -la";
        lt = "eza -T";
        r = "rsync -rthP";
        t = "tmux new -A";
        u = rebuildCmd;
        uu = "nix flake update --flake ${user.flake} && ${rebuildCmd}";

        G = {
          position = "anywhere";
          expansion = "| rg";
        };
      };
    };
  };
}

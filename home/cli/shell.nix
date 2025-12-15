{
  osConfig ? null,
  pkgs,
  user,
  ...
}:
let
  rebuildCmd = if osConfig == null then "nh home switch" else "nh os switch";
in
{
  programs = {
    bash = {
      enable = true;
      # Launch fish from bash to preserve login shell profile sourcing.
      # Setting users.users.*.shell = fish directly would skip /etc/profile.
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    fish = {
      enable = true;
      shellAbbrs = {
        d = "yazi";
        f = "$EDITOR";
        g = "lazygit";
        gcl = "git clone --depth=1";
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
      interactiveShellInit = ''
        set fish_greeting
      '';
    };
  };
}

{
  osConfig ? null,
  pkgs,
  user,
  ...
}:
let
  flakePath = "~/.config/home-manager";

  rebuildCmd =
    if osConfig == null then
      "home-manager switch --flake ${flakePath}#${user.hostName}"
    else
      "sudo nixos-rebuild switch --flake ${flakePath}";
in
{
  programs = {
    bash = {
      enable = true;
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
        bt = "aria2c --bt-tracker=(curl -fsSL https://trackerslist.com/all_aria2.txt)";
        d = "yazi";
        dl = "aria2c";
        f = "$EDITOR";
        g = "lazygit";
        gcl = "git clone --depth=1";
        gp = "git pull";
        j = "z";
        k = "btm";
        l = "eza -laF";
        lt = "eza -TF";
        r = "rsync -rthP";
        t = "tmux new -A";
        u = rebuildCmd;
        uu = "nix flake update --flake ${flakePath} && ${rebuildCmd}";

        G = {
          position = "anywhere";
          expansion = "| rg";
        };
      };
      interactiveShellInit = ''
        set fish_greeting
        set -gx COLORTERM truecolor
      '';
    };
  };
}

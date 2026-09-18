{
  lib,
  pkgs,
  user,
  osConfig ? null,
  ...
}:
let
  secretsFile = "$HOME/.config/secrets.sh";
  rebuildCmd = if osConfig == null then "nh home switch" else "nh os switch";

  skillAgents = [
    "claude-code"
    "codex"
  ];

  # Add a line here to install skills from another repo; "*" means all of them.
  skillSources = [
    {
      repo = "mattpocock/skills";
      skills = [ "*" ];
    }
    {
      repo = "herdrdev/herdr";
      skills = [ "herdr" ];
    }
  ];

  flags = flag: values: lib.concatMapStringsSep " " (v: "${flag} ${lib.escapeShellArg v}") values;
  # Reinstall from scratch so skills dropped from the list or upstream disappear too.
  updateSkills = pkgs.writeShellScriptBin "update-skills" ''
    set -e
    skills rm --all -g
    ${lib.concatMapStringsSep "\n" (
      s: "skills add ${s.repo} ${flags "-s" s.skills} -g ${flags "-a" skillAgents} -y"
    ) skillSources}
  '';
in
{
  home.packages = [ updateSkills ];
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        # not using sops-nix etc: builds should succeed without keys
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
        c = "claude";
        co = "codex";
        d = "yazi";
        f = "$EDITOR";
        g = "lazygit";
        gc = "git clone --depth=1";
        gl = "git pull";
        h = "herdr";
        k = "btm";
        l = "eza -la";
        lt = "eza -T";
        o = "opencode";
        r = "rsync -rthP";
        u = rebuildCmd;
        us = "update-skills";
        uu = "nix flake update --flake ${user.flake} && ${rebuildCmd}";

        G = {
          position = "anywhere";
          expansion = "| rg";
        };
      };
    };
  };
}

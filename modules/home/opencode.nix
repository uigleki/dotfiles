{ lib, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;

    settings = {
      autoupdate = false;
      plugin = [
        "@mohak34/opencode-notifier"
        "@tarquinen/opencode-dcp"
        "opencode-pty"
        "opencode-vibeguard"
      ];

      permission = {
        external_directory = "allow";
        bash = lib.genAttrs [
          # file destruction
          "rm *"
          "rmdir *"
          "mkfs *"
          "dd *"
          "find * -delete"

          # privilege escalation
          "sudo *"
          "su *"
          "chmod *"
          "chown *"

          # code execution
          "python* -c *"
          "node -e *"
          "ruby -e *"
          "perl -e *"
          "bash -c *"
          "sh -c *"
          "npx *"
          "bunx *"
          "eval *"
          "exec *"
          "xargs *"

          # environment injection
          "export *"
          "env *"
          "printenv *"

          # network access
          "curl *"
          "wget *"
          "ssh *"
          "scp *"
          "rsync *"
          "nc *"

          # git destructive
          "git rebase *"
          "git checkout -- *"
          "git clean *"
          "git restore *"
          "git branch -D *"

          "git push --force*"
          "git push -f*"
          "git reset --hard*"
          "git stash drop*"
          "git stash clear*"

          # publishing
          "npm publish*"
        ] (_: "ask");
      };
    };
  };
}

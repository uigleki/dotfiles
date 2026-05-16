{ pkgs, ... }:
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
        edit = "ask";
        bash = {
          "*" = "ask";
          "git diff*" = "allow";
          "git log*" = "allow";
          "git status*" = "allow";
          "openspec*" = "allow";
        };
      };
    };
  };
}

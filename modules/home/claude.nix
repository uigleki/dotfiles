{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;

    settings = {
      theme = "auto";
      model = "opus";
      permissions.defaultMode = "auto";
    };
  };
}

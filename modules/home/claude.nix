{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    enableMcpIntegration = true;

    settings = {
      theme = "auto";
      model = "opus";
      permissions.defaultMode = "auto";
    };
  };
}

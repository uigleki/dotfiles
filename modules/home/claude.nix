{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    enableMcpIntegration = true;

    settings = {
      enabledPlugins."superpowers@claude-plugins-official" = true;
      model = "opus";
      permissions.defaultMode = "auto";
      theme = "auto";
    };
  };
}

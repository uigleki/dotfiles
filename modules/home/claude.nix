{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    enableMcpIntegration = true;

    settings = {
      enabledPlugins."superpowers@claude-plugins-official" = true;
      env.CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
      model = "opus";
      permissions.defaultMode = "auto";
      theme = "auto";
    };
  };
}

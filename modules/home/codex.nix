{ pkgs, ... }:
{
  # not loaded — trust needs writable config
  programs.codex = {
    enable = true;
    package = pkgs.unstable.codex;
    enableMcpIntegration = true;

    settings = {
      plugins."superpowers@openai-curated".enabled = true;
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;
    };
  };
}

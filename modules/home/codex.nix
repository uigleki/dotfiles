{ pkgs, ... }:
{
  # not loaded — trust needs writable config
  programs.codex = {
    enable = true;
    package = pkgs.unstable.codex;
    enableMcpIntegration = true;

    settings = {
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;
    };
  };
}

{ pkgs, ... }:
{
  # not loaded — trust needs writable config
  programs.codex = {
    enable = true;
    package = pkgs.unstable.codex; # bun add -g @openai/codex

    settings = {
      approvals_reviewer = "auto_review";
      feedback.enabled = false;
      file_opener = "none";
      model_auto_compact_token_limit = 300000;
      notice.hide_rate_limit_model_nudge = true;
      otel.metrics_exporter = "none";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;
      web_search = "live";

      tui.status_line = [
        "model-with-reasoning"
        "fast-mode"
        "context-used"
        "context-window-size"
        "five-hour-limit"
        "weekly-limit"
        "current-dir"
      ];
    };
  };
}

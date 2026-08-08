# not loaded — trust needs writable config
# still the source of truth: ~/.codex/config.toml is hand-written from it
{ pkgs, ... }:
{
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
      personality = "none";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;
      skills.bundled.enabled = false;
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

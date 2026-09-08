# curl -fsSL https://chatgpt.com/codex/install.sh | sh
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.home) homeDirectory;
  settings = {
    model = "gpt-6-astra";
    model_reasoning_effort = "medium";

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

    features = {
      apps = false;
      tool_suggest = false;
    };

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
  declaredSettings = (pkgs.formats.toml { }).generate "codex-settings.toml" settings;
in
{
  programs.codex = {
    enable = true;
    package = null;
  };

  home = {
    packages = [ pkgs.bubblewrap ];

    # Nix settings win; undeclared state such as project trust remains writable.
    activation.codexSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run ${pkgs.writeShellScript "merge-codex-settings" ''
        set -eu
        umask 077
        mkdir -p ${lib.escapeShellArg "${homeDirectory}/.codex"}
        target=${lib.escapeShellArg "${homeDirectory}/.codex/config.toml"}
        touch "$target"
        merged=$(${pkgs.yq}/bin/tomlq -t -s '.[0] * .[1]' "$target" ${declaredSettings})
        printf '%s\n' "$merged" > "$target"
      ''}
    '';
  };

  # template for ~/.config/systemd/user/codex.service; keep temporary projects out of Nix
  # systemd.user.services.codex = {
  #   Unit.Description = "Codex Remote Control for ${project}";

  #   Service = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;

  #     WorkingDirectory = "${homeDirectory}/${project}";
  #     Environment = [
  #       "PATH=${homeDirectory}/.local/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"
  #     ];

  #     ExecStart = "${lib.getExe pkgs.bash} -lc 'exec ${lib.getExe pkgs.direnv} exec ${homeDirectory}/${project} ${homeDirectory}/.local/bin/codex remote-control start'";
  #     ExecStop = "${homeDirectory}/.local/bin/codex remote-control stop";

  #     Restart = "on-failure";
  #     RestartSec = 10;
  #   };

  #   Install.WantedBy = [ "default.target" ];
  # };
}

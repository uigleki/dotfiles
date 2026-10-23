# curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.home) homeDirectory;

      settings = {
        # retuned often
        model = "gpt-6-astra";
        model_reasoning_effort = "medium";

        analytics.enabled = false;
        feedback.enabled = false;

        features = {
          apps = false;
          memories = false;
        };

        include_collaboration_mode_instructions = false;
        model_auto_compact_token_limit = 300000;
        notice.hide_rate_limit_model_nudge = true;
        personality = "none";
        sandbox_mode = "workspace-write";
        sandbox_workspace_write.network_access = true;
        skills.bundled.enabled = false;

        tui = {
          auto_recap = false;
          show_tooltips = false;

          status_line = [
            "model-with-reasoning"
            "fast-mode"
            "context-used"
            "context-window-size"
            "five-hour-limit"
            "weekly-limit"
            "current-dir"
          ];
        };

        web_search = "live";
      };

      declaredSettings = (pkgs.formats.toml { }).generate "codex-settings.toml" settings;
    in
    {
      home = {
        # Nix settings win; undeclared state such as project trust remains writable.
        activation.codexSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          run ${pkgs.writeShellScript "merge-codex-settings" ''
            set -eu
            umask 077
            mkdir -p ${lib.escapeShellArg "${homeDirectory}/.codex"}
            target=${lib.escapeShellArg "${homeDirectory}/.codex/config.toml"}
            touch "$target"
            merged=$(${lib.getExe' pkgs.yq "tomlq"} -t -s '.[0] * .[1]' "$target" ${declaredSettings})
            printf '%s\n' "$merged" > "$target"
          ''}
        '';

        packages = [ pkgs.bubblewrap ];
      };

      programs.codex = {
        enable = true;
        package = null;
      };

      # template for ~/.config/systemd/user/codex.service; keep temporary projects out of Nix
      # systemd.user.services.codex = {
      #   Unit.Description = "Codex Remote Control for ${project}";
      #
      #   Service = {
      #     Type = "oneshot";
      #
      #     Environment = [
      #       "PATH=${homeDirectory}/.local/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"
      #     ];
      #
      #     ExecStart = "${lib.getExe pkgs.bash} -lc 'exec ${lib.getExe pkgs.direnv} exec ${homeDirectory}/${project} ${homeDirectory}/.local/bin/codex remote-control start'";
      #     ExecStop = "${homeDirectory}/.local/bin/codex remote-control stop";
      #     RemainAfterExit = true;
      #     Restart = "on-failure";
      #     RestartSec = 10;
      #     WorkingDirectory = "${homeDirectory}/${project}";
      #   };
      #
      #   Install.WantedBy = [ "default.target" ];
      # };
    };
}

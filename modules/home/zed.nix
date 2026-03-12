{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.desktop;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.unstable.zed-editor;
      mutableUserKeymaps = false;

      extensions = [
        "basher"
        "biome"
        "catppuccin"
        "catppuccin-icons"
        "dart"
        "docker-compose"
        "dockerfile"
        "emmet"
        "env"
        "git-firefly"
        "html"
        "ini"
        "justfile"
        "lua"
        "markdownlint"
        "nix"
        "opencode"
        "rainbow-csv"
        "ruff"
        "sql"
        "toml"
        "typos"
        "zig"
      ];

      userSettings = {
        theme = {
          light = "Catppuccin Latte";
          dark = "Catppuccin Macchiato";
        };
        icon_theme = {
          light = "Catppuccin Latte";
          dark = "Catppuccin Macchiato";
        };

        autosave = "on_focus_change";
        cursor_blink = false;
        helix_mode = true;
        relative_line_numbers = "enabled";
        use_smartcase_search = true;
        wrap_guides = [
          80
          120
        ];

        diagnostics.inline.enabled = true;
        git_panel.tree_view = true;
        inlay_hints.enabled = true;
        lsp.markdownlint.settings.MD013 = false;
        tabs.git_status = true;
        terminal.copy_on_select = true;

        auto_update = false;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
      };

      userKeymaps = [
        { bindings."ctrl-v" = "editor::Paste"; }
        {
          context = "!Terminal";
          bindings.home = [
            "workspace::SendKeystrokes"
            "escape"
          ];
        }
        {
          context = "Editor";
          bindings.f6 = "editor::SortLinesCaseSensitive";
        }
      ];
    };
  };
}

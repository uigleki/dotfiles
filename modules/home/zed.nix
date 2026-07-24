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
      enableMcpIntegration = true;
      mutableUserKeymaps = false;

      extensions = [
        "biome"
        "catppuccin"
        "catppuccin-icons"
        "csharp"
        "dart"
        "docker-compose"
        "dockerfile"
        "emmet"
        "env"
        "gdscript"
        "git-firefly"
        "html"
        "ini"
        "just"
        "log"
        "lua"
        "markdownlint"
        "nix"
        "rainbow-csv"
        "sql"
        "toml"
        "xml"
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

        auto_update = false;
        autosave = "on_focus_change";
        cursor_blink = false;
        diagnostics.inline.enabled = true;
        diff_view_style = "unified";
        git_panel.tree_view = true;
        helix_mode = true;
        lsp.markdownlint.settings.MD013 = false;
        relative_line_numbers = "enabled";
        semantic_tokens = "combined";
        sticky_scroll.enabled = true;
        tabs.git_status = true;
        terminal.copy_on_select = true;
        use_smartcase_search = true;

        wrap_guides = [
          80
          120
        ];
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

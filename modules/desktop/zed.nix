{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        package = pkgs.unstable.zed-editor;

        extensions = [
          "catppuccin"
          "catppuccin-icons"
          "csharp"
          "dart"
          "dockerfile"
          "env"
          "gdscript"
          "git-firefly"
          "html"
          "ini"
          "just"
          "log"
          "lua"
          "nix"
          "rainbow-csv"
          "sql"
          "toml"
          "xml"
        ];

        mutableUserKeymaps = false;
        mutableUserSettings = false;

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
            bindings."ctrl-s" = "workspace::Save";
            bindings.f6 = "editor::SortLinesCaseSensitive";
          }
        ];

        userSettings = {
          # panels
          agent.dock = "right";
          collaboration_panel.dock = "left";
          git_panel.dock = "left";
          git_panel.tree_view = true;
          outline_panel.dock = "left";
          project_panel.dock = "left";

          autosave = "on_focus_change";
          cursor_blink = false;
          diagnostics.inline.enabled = true;
          diff_view_style = "unified";
          format_on_save = "on";
          helix_mode = true;

          # Catppuccin, matching the rest of the desktop
          icon_theme = {
            light = "Catppuccin Latte";
            dark = "Catppuccin Macchiato";
          };

          theme = {
            light = "Catppuccin Latte";
            dark = "Catppuccin Macchiato";
          };

          relative_line_numbers = "enabled";
          semantic_tokens = "combined";
          sticky_scroll.enabled = true;
          tabs.git_status = true;

          telemetry = {
            diagnostics = false;
            metrics = false;
          };

          terminal.copy_on_select = true;
          use_smartcase_search = true;

          wrap_guides = [
            80
            120
          ];
        };
      };
    };
}

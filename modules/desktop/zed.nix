{
  homeManager.modules.desktop =
    { osConfig, pkgs, ... }:
    let
      inherit (osConfig.fonts.fontconfig) defaultFonts;
    in
    {
      programs.zed-editor = {
        enable = true;
        package = pkgs.unstable.zed-editor;

        extensions = [
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
          buffer_font_family = builtins.head defaultFonts.monospace;
          diagnostics.inline.enabled = true;
          diff_view_style = "unified";
          format_on_save = "on";
          helix_mode = true;

          relative_line_numbers = "enabled";
          semantic_tokens = "combined";
          sticky_scroll.enabled = true;
          tabs.git_status = true;

          telemetry = {
            diagnostics = false;
            metrics = false;
          };

          terminal.copy_on_select = true;
          ui_font_family = builtins.head defaultFonts.sansSerif;
          use_smartcase_search = true;

          wrap_guides = [
            80
            120
          ];
        };
      };

      xdg.mimeApps.defaultApplications."text/plain" = "dev.zed.Zed.desktop";
    };
}

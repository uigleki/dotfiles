{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.dev;
  isDesktop = config.myModules.desktop.enable;
in
{
  config = lib.mkIf (cfg.enable && isDesktop) {
    programs.zed-editor = {
      enable = true;
      package = pkgs.unstable.zed-editor;

      extensions = [
        "catppuccin"
        "catppuccin-icons"
        "dart"
        "html"
        "markdownlint"
        "toml"
      ];

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

      userSettings = {
        theme = {
          light = "Catppuccin Latte";
          dark = "Catppuccin Macchiato";
        };
        icon_theme = {
          light = "Catppuccin Latte";
          dark = "Catppuccin Macchiato";
        };

        autosave.after_delay.milliseconds = 1000;
        cursor_blink = false;
        helix_mode = true;
        relative_line_numbers = "enabled";
        use_smartcase_search = true;
        wrap_guides = [
          80
          120
        ];

        agent.play_sound_when_agent_done = true;
        diagnostics.inline.enabled = true;
        git_panel.tree_view = true;
        inlay_hints.enabled = true;
        lsp.markdownlint.settings.MD013 = false;
        minimap.show = "auto";
        terminal.copy_on_select = true;

        auto_update = false;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
      };
    };
  };
}

{
  flake.modules.homeManager.base = {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type file";
      fileWidgetCommand = "fd --type file . \\$dir"; # escaped so the fish widget, not hm-session-vars.sh, fills in the typed directory

      fileWidgetOptions = [
        "--preview='bat --color=always --style=numbers --line-range=:100 {}'"
      ];

      changeDirWidgetCommand = "fd --type dir . \\$dir";

      changeDirWidgetOptions = [
        "--preview='eza -TF --level=2 --color=always {}'"
      ];
    };
  };
}

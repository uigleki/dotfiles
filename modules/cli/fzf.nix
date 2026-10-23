{
  flake.modules.homeManager.base = {
    programs.fzf = {
      enable = true;
      # both widget commands escape $dir so the fish widget, not hm-session-vars.sh, fills in the typed directory
      changeDirWidgetCommand = "fd --type dir . \\$dir";

      changeDirWidgetOptions = [
        "--preview='eza -TF --level=2 --color=always {}'"
      ];

      defaultCommand = "fd --type file";
      fileWidgetCommand = "fd --type file . \\$dir";

      fileWidgetOptions = [
        "--preview='bat --color=always --style=numbers --line-range=:100 {}'"
      ];
    };
  };
}

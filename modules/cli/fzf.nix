{
  homeManager.modules.base.programs.fzf = {
    enable = true;

    # fzf runs these through $SHELL, so eval re-parses the fish-escaped $dir; \$ defers it past hm-session-vars.sh
    changeDirWidgetCommand = "eval fd --type dir . \\$dir";
    fileWidgetCommand = "eval fd --type file . \\$dir";

    changeDirWidgetOptions = [
      "--preview='eza -TF --level=2 --color=always {}'"
    ];

    defaultCommand = "fd --type file";

    fileWidgetOptions = [
      "--preview='bat --color=always --style=numbers --line-range=:100 {}'"
    ];
  };
}

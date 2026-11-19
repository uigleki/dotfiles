{
  homeManager.modules.base.programs.fzf = {
    enable = true;

    # fzf runs these through $SHELL, so eval re-parses the fish-escaped $dir; \$ defers it past hm-session-vars.sh
    changeDirWidgetCommand = "eval fd --type dir . \\$dir";

    changeDirWidgetOptions = [
      "--preview='eza -TF --level=2 --color=always {}'"
    ];

    defaultCommand = "fd --type file";
    fileWidgetCommand = "eval fd --type file . \\$dir";

    fileWidgetOptions = [
      "--preview='bat --color=always --style=numbers --line-range=:100 {}'"
    ];
  };
}

{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--preview='bat -n --color=always {}'" ];
    fileWidgetCommand = "fd --type f";
    historyWidgetOptions = [ "--preview=''" ];
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview='exa -TF --color=always {}'" ];
  };
}

{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--preview='bat -n --color=always {}'" ];
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview='bat -n --color=always {}'" ];
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview='exa -TF {}'" ];
    historyWidgetOptions = [ "--preview='echo {}'" "--preview-window=hidden" ];
  };
}

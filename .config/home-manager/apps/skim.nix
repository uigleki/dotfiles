{
  programs.skim = {
    enable = true;
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview='exa -TF {}'" ];
    defaultCommand = "fd --type f";
    defaultOptions = [ "--preview='bat -n --color=always {}'" ];
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview='bat -n --color=always {}'" ];
  };
}

{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type file --color=always";
    defaultOptions = [
      "--ansi"
      "--preview='bat --color=always --style=numbers --line-range=:500 {}'"
    ];
    fileWidgetCommand = "fd --type file --color=always";
    historyWidgetOptions = [ "--preview=''" ];
    changeDirWidgetCommand = "fd --type dir";
    changeDirWidgetOptions = [ "--preview='exa -TF --color=always {}'" ];
  };
}

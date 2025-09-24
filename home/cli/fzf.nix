{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type file";
    defaultOptions = [
      "--preview='bat --color=always --style=numbers --line-range=:100 {}'"
    ];
    fileWidgetCommand = "fd --type file";
    historyWidgetOptions = [ "--preview=''" ];
    changeDirWidgetCommand = "fd --type dir";
    changeDirWidgetOptions = [
      "--preview='eza -TF --level=2 --color=always {}'"
    ];
  };
}

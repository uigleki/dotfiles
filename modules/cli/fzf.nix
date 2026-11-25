{
  homeManager.modules.base.programs.fzf = {
    enable = true;

    # fzf runs these through $SHELL, so fish itself unescapes the fish-escaped $dir; \$ defers it past hm-session-vars.sh
    changeDirWidgetCommand = "fish --no-config -c 'fd --type dir . (string unescape -- \\$dir)'";
    fileWidgetCommand = "fish --no-config -c 'fd --type file . (string unescape -- \\$dir)'";

    changeDirWidgetOptions = [
      "--preview='eza -TF --level=2 --color=always {}'"
    ];

    defaultCommand = "fd --type file";

    fileWidgetOptions = [
      "--preview='bat --color=always --style=numbers --line-range=:100 {}'"
    ];
  };
}

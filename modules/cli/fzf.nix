{
  homeManager.modules.base.programs.fzf =
    let
      # fzf runs the widget commands through $SHELL, so fish itself unescapes the fish-escaped $dir; \$ defers it past hm-session-vars.sh
      fdIn = type: "fish --no-config -c 'fd --type ${type} . (string unescape -- \\$dir)'";
    in
    {
      enable = true;
      changeDirWidgetCommand = fdIn "dir";
      fileWidgetCommand = fdIn "file";

      changeDirWidgetOptions = [
        "--preview='eza -TF --level=2 --color=always {}'"
      ];

      defaultCommand = "fd --type file";

      fileWidgetOptions = [
        "--preview='bat --color=always --style=numbers --line-range=:100 {}'"
      ];
    };
}

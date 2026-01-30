{
  programs.kitty = {
    enable = true;
    settings = {
      copy_on_select = "yes";
      cursor_blink_interval = 0;
      window_padding_width = 4;
    };

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
    };
  };
}

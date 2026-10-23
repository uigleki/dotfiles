{
  flake.modules = {
    nixos.server =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.kitty.terminfo ]; # ssh from kitty keeps TERM=xterm-kitty
      };

    homeManager.desktop.programs.kitty = {
      enable = true;

      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";
      };

      settings = {
        copy_on_select = "yes";
        cursor_blink_interval = 0;
        scrollback_lines = 10000;
        window_padding_width = 4;
      };
    };
  };
}

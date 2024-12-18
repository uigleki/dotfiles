{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "gruvbox_light";
      editor = {
        auto-save = true;
        cursorline = true;
        line-number = "relative";
        idle-timeout = 0;
        cursor-shape.insert = "bar";
        soft-wrap.enable = true;
      };
      keys.insert.home = "normal_mode";
    };
  };
}

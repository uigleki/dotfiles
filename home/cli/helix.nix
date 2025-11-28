{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        auto-save.after-delay = {
          enable = true;
          timeout = 1000;
        };
        line-number = "relative";
        cursorline = true;
        completion-timeout = 10;
        cursor-shape.insert = "bar";
      };
      keys.insert.home = "normal_mode";
    };
  };
}

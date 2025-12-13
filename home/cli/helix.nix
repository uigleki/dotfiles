{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        cursorline = true;
        completion-timeout = 5;
        bufferline = "multiple";
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        cursor-shape.insert = "bar";
        auto-save.after-delay = {
          enable = true;
          timeout = 1000;
        };
      };
      keys.insert = {
        # Caps Lock remapped to Home externally; use it to exit insert mode
        home = "normal_mode";
      };
    };
  };
}

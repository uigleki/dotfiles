{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        cursorline = true;
        completion-timeout = 5; # instant completion (docs recommend 5 for instant)
        bufferline = "multiple";
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        cursor-shape.insert = "bar";
        auto-save.after-delay = {
          enable = true;
          timeout = 1000; # 1 second
        };
      };

      # Caps Lock remapped to Home externally; use it to exit insert mode
      keys.insert.home = "normal_mode";
    };
  };
}

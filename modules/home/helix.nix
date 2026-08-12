{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      editor = {
        bufferline = "multiple";
        completion-timeout = 5; # 5 ms; instant completion (docs recommend 5 for instant)
        cursor-shape.insert = "bar";
        cursorline = true;
        indent-guides.render = true;
        line-number = "relative";
        trim-final-newlines = true;
        trim-trailing-whitespace = true;

        auto-save.after-delay = {
          enable = true;
          timeout = 1000; # 1 second in ms
        };
      };

      # Caps Lock remapped to Home externally; use it to exit insert mode
      keys.insert.home = "normal_mode";
    };
  };
}

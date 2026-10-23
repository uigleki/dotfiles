{
  flake.modules.homeManager.base = {
    programs.helix = {
      enable = true;
      defaultEditor = true;

      settings = {
        editor = {
          auto-save.after-delay = {
            enable = true;
            timeout = 1000; # 1 second in ms
          };

          bufferline = "multiple";
          completion-timeout = 5; # ms
          cursor-shape.insert = "bar";
          cursorline = true;
          indent-guides.render = true;
          line-number = "relative";
          trim-final-newlines = true;
          trim-trailing-whitespace = true;
        };

        # Caps Lock remapped to Home externally; use it to exit insert mode
        keys.insert.home = "normal_mode";
      };
    };
  };
}

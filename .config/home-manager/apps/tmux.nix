{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    escapeTime = 0;
    mouse = true;
    extraConfig = ''
      # Enable true color
      set -ga terminal-overrides ",$TERM:Tc"

      bind -n M-j next-window
      bind -n M-k previous-window
      bind -n M-n new-window
      bind -n M-q detach

      set -g status-style "bg=black, fg=yellow"
      set -g status-left "#{?client_prefix,#[reverse]prefix,}"
      setw -g monitor-activity on
    '';
  };
}

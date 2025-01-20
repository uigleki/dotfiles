{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    mouse = true;
    extraConfig = ''
      set -g default-terminal "$TERM"
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

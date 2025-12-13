{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [ sensible ];
    extraConfig = ''
      set -ga terminal-overrides ",*:Tc" # enable true color

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

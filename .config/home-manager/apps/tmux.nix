{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # 设置正确的终端，并使用真彩色
      set -g default-terminal "$TERM"
      set -ga terminal-overrides ",$TERM:Tc"

      # 加载配置文件
      bind r source-file /etc/tmux.conf \; display-message "Config reloaded"

      # 设置本地 <prefix> 为 Ctrl+S 组合键
      unbind C-b
      set -g prefix C-s
      bind C-s send-prefix

      # 设置远程 <prefix> 为 Ctrl+B 组合键
      bind-key -n C-b send-prefix

      # 进入上或下一个窗口
      bind -n M-j next-window
      bind -n M-k previous-window

      # 新增标签
      bind -n M-n new-window

      # 分离会话
      bind C-d detach

      # 支持鼠标
      set-option -g mouse on

      # 解决 esc 延迟
      set -s escape-time 0

      # 显示 prefix 激活状态
      set -g status-left "#{?client_prefix,#[reverse]prefix,}"

      # 状态栏前景背景色
      set -g status-style "bg=black, fg=yellow"

      # 非当前窗口有内容更新时在状态栏通知
      setw -g monitor-activity on
    '';
  };
}

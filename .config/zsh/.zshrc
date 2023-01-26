# 如果存在于 tty 会话中，则启动复用器
if [ "$XDG_SESSION_TYPE" = "tty" ] && [ -z "$ZELLIJ" ] && [ -x "$(command -v zellij)" ]; then
    exec zellij attach --create
elif [ -z "$ZSH" ] && [ -x "$(command -v fish)" ]; then
    exec fish
fi

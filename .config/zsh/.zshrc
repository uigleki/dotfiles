# 如果存在于 tty 会话中，则启动复用器
if [ "$XDG_SESSION_TYPE" = "tty" ] && [ -z "$TMUX" ] && [ -x "$(command -v tmux)" ]; then
    exec tmux new -A
elif [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" ]] && [ -x "$(command -v fish)" ]; then
    exec fish
fi

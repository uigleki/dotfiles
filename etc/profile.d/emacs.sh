# emacs 自启动，使用真彩色
if [ -z "$SSH_TTY" ] && [ -x "$(command -v zellij)" ]; then
    COLORTERM=truecolor emacs --daemon &>/dev/null &
fi

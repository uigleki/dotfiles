# 在图形环境下，emacs 自启动，使用真彩色
if [ "$XDG_SESSION_TYPE" != 'tty' ] && [ -x "$(command -v emacs)" ]; then
    COLORTERM=truecolor emacs --daemon &>/dev/null &
fi

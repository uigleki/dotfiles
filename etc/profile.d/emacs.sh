# emacs 自启动，使用真彩色
if [ -x "$(command -v emacs)" ]; then
    COLORTERM=truecolor emacs --daemon &>/dev/null &
fi

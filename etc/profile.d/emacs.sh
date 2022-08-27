# 启动 emacs 守护进程，使用真彩色
if [ -x "$(command -v emacsclient)" ]; then
    (COLORTERM=truecolor emacsclient -nt &>/dev/null &)
fi

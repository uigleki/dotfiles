# 启动 emacs 守护进程
if [ -x "$(command -v emacsclient)" ]; then
    (emacsclient -nt &>/dev/null &)
fi

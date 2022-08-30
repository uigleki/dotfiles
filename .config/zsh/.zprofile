# 启动 emacs 守护进程
if [ -z "$(pidof emacs)" ] && [ -x "$(command -v emacs)" ]; then
    (emacs --daemon &>/dev/null &)
fi

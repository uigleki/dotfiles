# 启动 emacs 守护进程
#
# 第一次启动 emacs 需要联网下载插件，如果启动失败，命令 `killall emacs` 关闭守护进程，联网后再启动 emacs.

if [ -z "$(pidof emacs)" ] && [ -x "$(command -v emacs)" ]; then
    (emacs --daemon &>/dev/null &)
fi

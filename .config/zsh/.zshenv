# 语言
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export LC_CTYPE=en_US.UTF-8

# 输入法
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

# 编辑器
if [ -x "$(command -v emacs)" ]; then
    export COLORTERM=truecolor      # 使用真彩色
    export ALTERNATE_EDITOR=""      # 必须为空，emacsclient 才会自动启用守护进程
    export EDITOR="emacsclient -t"
    export VISUAL="emacsclient -c -a emacs"
else
    export EDITOR=nvim
fi

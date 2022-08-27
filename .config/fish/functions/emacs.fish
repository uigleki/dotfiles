# 自动创建 emacs 的守护进程
function emacs --wraps='emacsclient -c' --description 'alias emacs=emacsclient -c'
    emacsclient -c $argv
end
# emacs 连接到守护进程
function emacs --wraps='emacsclient -t' --description 'alias emacs=emacsclient -t'
    emacsclient -t $argv
end
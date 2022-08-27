# 自动创建 emacs 的守护进程
function emacsclient
    command emacsclient -a "" -t $argv
end
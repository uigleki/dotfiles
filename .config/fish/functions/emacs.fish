# 使用 emacs 的守护进程
function emacs
  emacsclient -a "" -t $argv;
end

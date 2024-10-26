;;; 环境自动加载工具

(use-package direnv
  :custom
  (direnv-always-show-summary nil)      ; 不显示通知
  :config
  (direnv-mode))

(provide 'init-direnv)

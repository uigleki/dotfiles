;;; 语言服务器协议的客户端

(use-package lsp-mode
  :hook
  ((python-mode
    sh-mode) . lsp)
  (lsp-mode . lsp-enable-which-key-integration)
  :custom
  (lsp-keymap-prefix "C-c l")           ; 前缀键
  :commands lsp)

(when *is-graphic*
  (use-package lsp-ui
    :custom
    (lsp-ui-sideline-show-code-actions t) ; 边线显示代码操作
    :commands lsp-ui-mode)

  (use-package dap-mode
    :config
    (require 'dap-python)))

(provide 'init-lsp-mode)

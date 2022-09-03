;;; 语言服务器协议的客户端

(use-package lsp-mode
  :hook
  ((python-mode
    sh-mode) . lsp)
  (lsp-mode . lsp-enable-which-key-integration)
  :custom
  (lsp-keymap-prefix "C-c l")
  :commands lsp)

(when *is-graphic*
  (use-package lsp-ui
    :commands lsp-ui-mode)

  (use-package dap-mode))

(provide 'init-lsp-mode)

;;; 语言服务器协议的客户端

(use-package lsp-mode
  :hook
  (prog-mode . lsp)
  (lsp-mode . lsp-enable-which-key-integration)
  :custom
  (lsp-keymap-prefix "C-c l")
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)

(use-package dap-mode)

(provide 'init-lsp-mode)

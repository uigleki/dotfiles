;;; 语言服务器协议的客户端

(use-package eglot
  :hook ((python-mode
          sh-mode) . eglot-ensure))

(provide 'init-eglot)

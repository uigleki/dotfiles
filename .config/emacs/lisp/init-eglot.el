;;; 语言服务器协议的客户端
;;
;; M-. => 跳转到符号的定义
;; M-? => 查找符号调用

(use-package eglot
  :hook ((python-mode
          sh-mode) . eglot-ensure))

(provide 'init-eglot)

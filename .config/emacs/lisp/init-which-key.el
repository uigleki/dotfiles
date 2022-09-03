;;; 显示可用按键绑定

(use-package which-key
  :custom
  ;; 守护程序下，解决最后一行被隐藏的问题
  (which-key-allow-imprecise-window-fit nil)
  :config
  (which-key-mode 1))

(provide 'init-which-key)

;;; 模态编辑：李杀飞键
;;
;; 只加载飞键的函数，因为飞键模式本身有很多问题，而且和其他模式冲突

(use-package xah-fly-keys
  :custom
  ;; 不要删除 emacs 的默认快捷键
  (xah-fly-use-control-key nil)
  (xah-fly-use-meta-key nil))

(provide 'init-xah-fly-keys)

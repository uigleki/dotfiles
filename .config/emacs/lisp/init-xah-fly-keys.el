;;; 模态编辑：李杀飞键
;;
;; 只加载飞键的函数，因为飞键模式本身有很多问题，而且和其他模式冲突

(use-package xah-fly-keys
    :custom
    (xah-fly-use-control-key nil) ; 禁用对 Emacs 控件键绑定的更改
    (xah-fly-use-meta-key nil)) ; 禁用对 Emacs 元键绑定的更改

(provide 'init-xah-fly-keys)

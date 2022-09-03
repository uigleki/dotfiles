;;; 模态编辑：杀飞键

(use-package xah-fly-keys
  :bind
  ("<escape>" . xah-fly-command-mode-activate)
  :config
  (xah-fly-keys-set-layout "qwerty")
  (xah-fly-keys 1))

(provide 'init-xah-fly-keys)

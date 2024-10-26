;;; 编辑缓冲区补全

(use-package corfu
  :bind
  (:map corfu-map
        ([escape] . corfu-quit))        ; esc 关闭补全窗口
  :custom
  (corfu-auto t)                        ; 启用自动补全
  (corfu-auto-delay 0)                  ; 立即显示补全
  (corfu-auto-prefix 1)                 ; 输入 1 个字符后显示补全
  :config
  (global-corfu-mode 1))

(use-package corfu-terminal             ; 在非图形环境使用 corfu
  :config (corfu-terminal-mode 1))

(when *is-graphic*
  (use-package corfu-doc
    :hook (corfu-mode . corfu-doc-mode)))

(provide 'init-corfu)

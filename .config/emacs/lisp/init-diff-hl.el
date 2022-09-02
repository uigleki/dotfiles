;;; git 差异显示

(use-package diff-hl
  :hook
  (after-init . global-diff-hl-mode)
  (dired-mode . diff-hl-dired-mode)
  :config
  (unless *is-graphic*
    (diff-hl-margin-mode)))

(provide 'init-diff-hl)

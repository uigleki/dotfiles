(use-package diff-hl
  :hook
  (after-init . global-diff-hl-mode)
  (dired-mode . diff-hl-dired-mode)
  :config
  (unless (display-graphic-p)
    (diff-hl-margin-mode)))

(provide 'init-diff-hl)

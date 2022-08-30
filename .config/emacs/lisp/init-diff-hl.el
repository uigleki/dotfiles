(use-package diff-hl
  :hook
  (dired-mode . diff-hl-dired-mode)
  (diff-hl-mode-on . (lambda ()
                       (unless (window-system)
                         (diff-hl-margin-local-mode))))
  :config
  (global-diff-hl-mode))

(provide 'init-diff-hl)

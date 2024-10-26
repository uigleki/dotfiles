;;; 文件管理器

(use-package dirvish
  :bind ([remap dired] . dirvish)
  :config (dirvish-override-dired-mode))

(provide 'init-dirvish)

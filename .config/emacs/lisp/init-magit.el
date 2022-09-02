;;; git 用户界面

(use-package magit
  :bind (:map mode-specific-map
              ("y" . magit)))

(provide 'init-magit)

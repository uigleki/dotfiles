;;; git 用户界面

(use-package magit
  :bind (:map project-prefix-map
              ("m" . magit)))

(provide 'init-magit)

;;; 软件包更新
;;
;; 只绑定更新软件快捷键，因为更新期间不能操作

(use-package auto-package-update
  :bind
  (:map mode-specific-map
        ("P" . auto-package-update-now))
  :custom
  (auto-package-update-delete-old-versions t))

(provide 'init-auto-package-update)

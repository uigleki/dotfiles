;;; 欢迎界面仪表板

(use-package dashboard
  :custom
  (initial-buffer-choice (lambda ()
                           (get-buffer-create "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

(provide 'init-dashboard)

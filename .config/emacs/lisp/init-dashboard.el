;;; 欢迎界面仪表板

(use-package dashboard
  :custom
  (dashboard-center-content t)          ; 内容居中
  (dashboard-set-footer nil)            ; 禁用随机脚注
  (initial-buffer-choice (lambda ()     ; 守护进程开始页
                           (get-buffer-create "*dashboard*")))
  ;; 仪表板内容
  (dashboard-items '((recents  . 7)
                     (agenda . 7)))
  :config
  (dashboard-setup-startup-hook))

(provide 'init-dashboard)

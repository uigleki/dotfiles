;;; 组织模式

(use-package org
  :bind
  (:map mode-specific-map
        ("e" . org-agenda)
        ("E" . org-capture))
  (:map org-mode-map
        ("C-c v" . visible-mode))
  :custom
  (org-enforce-todo-dependencies t)     ; 强制任务依赖
  (org-image-actual-width (list 500))   ; 图片可以调整宽度，默认 500
  (org-log-done 'time)                  ; 记录完成时间
  (org-startup-indented t)              ; 启用缩进排版
  ;; 代办事项
  (org-directory "~/dilnu/org")
  (org-agenda-files `(,org-directory))         ; 日程扫描目录
  (org-capture-templates
   `(("t" "Todo" entry (file+headline ,(concat org-directory "/todo.org") "Tasks")
      "* TODO %^{任务名}\n%u\n%a")
     ("d" "Diary" entry (file+datetree ,(concat org-directory "/diary.org"))
      "* %^{heading}\n%?")
     ("i" "Idea" entry (file+datetree ,(concat org-directory "/idea.org"))
      "* %^{heading}\n%?")
     ("n" "Notes" entry (file ,(concat org-directory "/note.org"))
      "* %^{heading} %U %^g\n%?"
      :empty-lines-before 1)))
  :config
  ;; 自动创建日程目录，否则要报错
  (dolist (dir org-agenda-files)
    (make-directory dir t))

  ;; 可以在 org 缓冲区执行的语言
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t))))

(provide 'init-org)

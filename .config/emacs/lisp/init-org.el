(use-package org
  :bind
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
  (:map org-mode-map ("C-c v" . visible-mode))
  :custom
  (org-enforce-todo-dependencies t)     ; 强制任务依赖
  (org-image-actual-width nil)          ; 图片可以调整大小
  (org-log-done 'time)                  ; 记录完成时间
  (org-startup-indented t)              ; 启用缩进排版
  ;; 代办事项
  (org-agenda-files '("~/org"))         ; 日程扫描目录
  (org-default-notes-file "~/org/todo.org")
  (org-capture-templates
   '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
      "* TODO %^{任务名}\n%u\n%a")
     ("d" "Diary" entry (file+datetree "~/org/diary.org")
      "* %^{heading}\n%?")
     ("i" "Idea" entry (file "~/org/idea.org")
      "* %^{heading} %U\n- %?")
     ("n" "Notes" entry (file "~/org/note.org")
      "* %^{heading} %t %^g\n%?")))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages            ; 可以在 org 缓冲区执行的语言
   '((emacs-lisp . t)
     (python . t)
     (shell . t))))

(provide 'init-org)

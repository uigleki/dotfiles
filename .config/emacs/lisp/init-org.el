(use-package org
  :bind
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
  (:map org-mode-map ("C-c v" . visible-mode))
  :custom
  (org-agenda-files '("~/org"))
  (org-default-notes-file "~/org/todo.org")
  (org-log-done 'time)                  ; 记录完成时间
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

(use-package org
  :bind
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
  (:map org-mode-map ("C-c v" . visible-mode))
  :custom
  (org-agenda-files '("~/org"))
  (org-default-notes-file "~/org/todo.org"))

(provide 'init-org)

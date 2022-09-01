;;; 撤销树可视化

(use-package undo-tree
  :custom
  (undo-tree-history-directory-alist `(("." . ,(expand-file-name ".undo-tree" user-emacs-directory))))
  (undo-tree-visualizer-diff t)
  (undo-tree-visualizer-timestamps t)
  :config
  (global-undo-tree-mode 1))

(provide 'init-undo-tree)

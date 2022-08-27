(use-package tree-sitter
  :hook ((python-mode
          sh-mode) . tree-sitter-hl-mode)
  :config (global-tree-sitter-mode))

(use-package tree-sitter-langs)

(provide 'init-tree-sitter)

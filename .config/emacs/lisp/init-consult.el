;;; 命令缓冲区跳转预览

(use-package consult
  :bind
  ([remap apropos-command] . consult-apropos)
  ([remap goto-line] . consult-goto-line)
  ([remap imenu] . consult-imenu)
  ([remap project-find-regexp] . consult-git-grep)
  ([remap project-switch-to-buffer] . consult-project-buffer)
  ([remap switch-to-buffer] . consult-buffer)
  ([remap yank-pop] . consult-yank-pop)
  (:map mode-specific-map
        ("f" . consult-find)
        ("q" . consult-ripgrep)))

(provide 'init-consult)

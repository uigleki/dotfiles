;;; 命令缓冲区跳转预览
;;
;; 在命令缓冲区的候选列表中，预览选中的选项。

(use-package consult
  :bind
  ([remap apropos-command] . consult-apropos)      ; key: C-h a
  ([remap goto-line] . consult-goto-line)          ; key: M-g g
  ([remap imenu] . consult-imenu)                  ; key: C-c i
  ([remap project-find-regexp] . consult-git-grep) ; key: C-c p g
  ([remap project-switch-to-buffer] . consult-project-buffer) ; key: C-c p b
  ([remap switch-to-buffer] . consult-buffer) ; key: C-c b
  ([remap yank-pop] . consult-yank-pop)       ; key: M-y
  (:map mode-specific-map
        ("f" . consult-find)
        ("q" . consult-ripgrep)))

(provide 'init-consult)

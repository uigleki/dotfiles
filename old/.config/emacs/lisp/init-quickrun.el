;;; 运行编辑缓冲区

(use-package quickrun
  :bind (:map mode-specific-map
              ("R" . quickrun-shell)))

(provide 'init-quickrun)

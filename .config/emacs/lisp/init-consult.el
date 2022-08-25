(use-package consult
  :bind
  ([remap switch-to-buffer] . consult-buffer)
  ([remap goto-line] . consult-goto-line)
  (:map mode-specific-map
        ("f" . consult-find)
        ("q" . consult-ripgrep)))

(provide 'init-consult)

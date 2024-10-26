;;; 补全候选排序

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  (orderless-matching-styles '(orderless-initialism
                               orderless-literal
                               orderless-regexp)))

(provide 'init-orderless)

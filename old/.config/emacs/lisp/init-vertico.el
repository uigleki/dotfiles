;;; 命令缓冲区补全

(use-package vertico
  :config (vertico-mode))

(use-package savehist                   ; 按历史位置排序
  :config (savehist-mode))

(use-package marginalia                 ; 命令缓冲区注释
  :config (marginalia-mode))

(provide 'init-vertico)

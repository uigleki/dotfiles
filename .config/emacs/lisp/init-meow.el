;;; 模态编辑：猫态编辑
;;
;; 键位使用李杀的飞键键位

(use-package meow
  :config
  (defun meow-setup ()                  ; qwerty 按键绑定
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("<escape>" . ignore)
     '("i" . meow-prev)
     '("k" . meow-next))

    ;; 领导键映射，包括 mode-specific-map
    (meow-leader-define-key
     '("3" . delete-window)
     '("4" . split-window-right)
     '("5" . balance-windows)
     '("6" . xah-upcase-sentence)
     '("9" . ispell-word)

     '("r" . query-replace)
     '("t" . xah-show-kill-ring)
     '("y" . xah-search-current-word)
     ;; '("u" . xah-close-current-buffer)

     '("a" . mark-whole-buffer)
     '("s" . exchange-point-and-mark)
     '("f" . switch-to-buffer)
     ;; '("g" . kill-line)
     '("h" . beginning-of-buffer)
     '(";" . save-buffer)

     ;; '("x" . xah-cut-all-or-region)
     ;; '("c" . xah-copy-all-or-region)
     '("n" . end-of-buffer)
     '("m" . dired-jump)

     '("ie" . ido-find-file)
     '("ir" . xah-open-last-closed)
     '("if" . xah-open-file-at-cursor)
     '("ig" . xah-copy-file-path)
     '("i;" . write-file)
     '("il" . xah-new-empty-buffer)
     '("kr" . query-replace-regexp)

     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet))

    ;; 普通键映射
    (meow-normal-define-key
     '("C-d" . pop-global-mark)
     '("C-q" . quoted-insert)
     '("<escape>" . ignore)

     '("`" . other-frame)
     '("1" . xah-extend-selection)
     '("2" . ignore)
     '("3" . delete-other-windows)
     '("4" . split-window-below)
     '("5" . delete-char)
     '("6" . xah-select-block)
     '("7" . xah-select-line)
     '("8" . xah-extend-selection)
     '("9" . xah-select-text-in-quote)
     '("0" . xah-pop-local-mark-ring)
     '("-" . xah-backward-punct)
     '("=" . xah-forward-punct)

     '("q" . xah-reformat-lines)
     '("w" . xah-shrink-whitespaces)
     '("e" . backward-kill-word)
     '("r" . kill-word)
     '("t" . set-mark-command)
     '("y" . undo)
     '("u" . backward-word)
     '("i" . previous-line)
     '("o" . forward-word)
     '("p" . xah-insert-space-before)
     '("[" . hippie-expand)
     '("]" . ignore)

     '("a" . execute-extended-command)
     '("s" . open-line)
     '("d" . xah-delete-backward-char-or-bracket-text)
     '("f" . meow-append)
     '("g" . xah-delete-current-text-block)
     '("h" . xah-beginning-of-line-or-block)
     '("j" . backward-char)
     '("k" . next-line)
     '("l" . forward-char)
     '(";" . xah-end-of-line-or-block)
     '("'" . xah-cycle-hyphen-lowline-space)

     '("z" . xah-comment-dwim)
     '("x" . xah-cut-line-or-region)
     '("c" . xah-copy-line-or-region)
     '("v" . xah-paste-or-paste-previous)
     '("b" . xah-toggle-letter-case)
     '("n" . isearch-forward)
     '("m" . xah-backward-left-bracket)
     '("," . xah-next-window-or-frame)
     '("." . xah-forward-right-bracket)
     '("/" . xah-goto-matching-bracket)))

  (meow-setup)
  (meow-global-mode 1))

(provide 'init-meow)

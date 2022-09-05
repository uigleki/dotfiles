;;; 模态编辑：猫态编辑
;;
;; 键位使用李杀的飞键键位

(use-package meow
  :config
  ;; 我的大写键绑定 home 键，让 home 键等于 esc 键
  (define-key key-translation-map (kbd "<home>") (kbd "<escape>"))
  (defun meow-setup ()                  ; qwerty 按键绑定
    ;; 移动模式键映射
    (meow-motion-overwrite-define-key
     '("<escape>" . ignore)
     '("i" . previous-line)
     '("k" . next-line)
     '("," . xah-next-window-or-frame))

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
     '("u" . xah-close-current-buffer)

     '("a" . mark-whole-buffer)
     '("s" . exchange-point-and-mark)
     '("f" . switch-to-buffer)
     '("G" . kill-line)                 ; 冲突 meow 的 C-M-
     '("H" . beginning-of-buffer)       ; 冲突 meow 的 C-h
     '(";" . save-buffer)

     '("X" . xah-cut-all-or-region)     ; 冲突 meow 的 C-x
     '("C" . xah-copy-all-or-region)    ; 冲突 meow 的 C-c
     '("n" . end-of-buffer)
     '("M" . dired-jump)                ; 冲突 meow 的 M-

     '("ie" . ido-find-file)
     '("ir" . xah-open-last-closed)
     '("if" . xah-open-file-at-cursor)
     '("ig" . xah-copy-file-path)
     '("i;" . write-file)
     '("il" . xah-new-empty-buffer)
     '("kr" . query-replace-regexp))

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

     '("Q" . xah-reformat-lines)        ; 冲突 quit
     '("q" . meow-quit)
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

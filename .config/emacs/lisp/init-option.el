;;;; emacs 默认行为选项

;;; 提升性能

;; 提升垃圾收集阈值，减少垃圾收集的频率来加快启动速度
(setq gc-cons-threshold most-positive-fixnum)

;; 启动后，降低垃圾收集阈值使垃圾收集暂停更快，减少卡顿
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 128 1024 1024))))

;; 提高进程通信量
(setq read-process-output-max (* 1024 1024))

;;; 函数选项

;; 使用 UTF-8
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)

(global-display-line-numbers-mode 1)    ; 显示行号
(setq display-line-numbers-type 'relative) ;显示相对行号

(fset 'yes-or-no-p 'y-or-n-p)           ; 在询问是或否时使用简短的回答
(global-hl-line-mode t)                 ; 突出显示当前行
(menu-bar-mode -1)                      ; 禁用菜单栏
(xterm-mouse-mode 1)                    ; 启用鼠标

;;; 设置默认值

(setq-default
 eldoc-echo-area-use-multiline-p nil    ; 不要显示多行 eldoc
 inhibit-splash-screen t                ; 禁用启动画面
 initial-scratch-message nil            ; 禁用暂存讯息
 ring-bell-function 'ignore             ; 禁用响铃
 visible-cursor nil                     ; 禁用光标闪烁
 create-lockfiles nil                   ; 禁用锁定文件

 ;; 备份设置
 backup-directory-alist `((".*" . ,temporary-file-directory))
 auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
 backup-by-copying t
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t

 column-number-mode t                   ; 显示当前列号
 indent-tabs-mode nil                   ; 使用空格代替制表符
 mouse-yank-at-point t                  ; 鼠标粘贴在光标处
 require-final-newline t)               ; 添加最后的换行符

;;; 钩子

;; 括号自动配对
(add-hook 'prog-mode-hook 'electric-pair-local-mode)
(add-hook 'conf-mode-hook 'electric-pair-local-mode)
;; 删除选择模式
(add-hook 'after-init-hook 'delete-selection-mode)
;; 自动同步外部修改
(add-hook 'after-init-hook 'global-auto-revert-mode)
;; 删除尾随空格
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; 图形界面

(when *is-graphic*
  (blink-cursor-mode -1)                ; 禁用光标闪烁
  (tool-bar-mode -1)                    ; 禁用工具栏
  (scroll-bar-mode -1)                  ; 禁用滚动条

  ;; 字体
  (add-to-list 'default-frame-alist '(font . "Monospace-16"))

  (defun set-chinese-font (&optional frame)
    "设置中文字体"
    (with-selected-frame (or frame (selected-frame))
      (when (display-graphic-p)
        (let ((chinese-font "Noto Sans Mono CJK SC-16.5"))
          (dolist (charset '(kana han cjk-misc bopomofo))
            (set-fontset-font "fontset-default" charset chinese-font)))
        (remove-hook 'after-make-frame-functions #'set-chinese-font))))

  (if (daemonp)
      (add-hook 'after-make-frame-functions #'set-chinese-font)
    (set-chinese-font)))

(provide 'init-option)

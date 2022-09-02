;; 设定源码加载路径
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;; 自定义信息文件位置
(setq custom-file (locate-user-emacs-file "custom.el"))

;;; 加载配置

(require 'init-version)                 ; 检查版本
(require 'init-option)                  ; 默认选项
(require 'init-use-package)             ; 包管理器
(require 'init-gruvbox-theme)           ; gruvbox 主题
(require 'init-doom-modeline)           ; 模式行样式
(require 'init-keymap)                  ; 按键绑定
(require 'init-dashboard)               ; 欢迎界面

;; 补全
(require 'init-saveplace)               ; 记住光标位置
(require 'init-which-key)               ; 显示按键绑定
(require 'init-undo-tree)               ; 撤销树
(require 'init-recentf)                 ; 最近文件
(require 'init-orderless)               ; 补全候选排序
(require 'init-vertico)                 ; 命令缓冲区补全
(require 'init-corfu)                   ; 编辑缓冲区补全
(require 'init-consult)                 ; 跳转预览
(require 'init-diff-hl)                 ; git 差异显示
(require 'init-magit)                   ; git 管理

;; 语言
(require 'init-go-translate)            ; 语言翻译
(require 'init-eglot)                   ; 语言客户端
(require 'init-flymake)                 ; 语法检查
(require 'init-org)                     ; org 模式
(require 'init-tree-sitter)             ; 语法树
(require 'init-quickrun)                ; 执行缓冲区
(require 'init-realgud)                 ; 调试器

;; 语言包
(use-package markdown-mode)
(use-package lua-mode)

(provide 'init)

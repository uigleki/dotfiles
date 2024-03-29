;;; 软件包配置器

;; 添加软件源
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(unless (bound-and-true-p package--initialized)
  (package-initialize))                 ; 初始化包管理器

;; 如果 use-package 没安装
(unless (package-installed-p 'use-package)
  (package-refresh-contents)            ; 更新本地缓存
  (package-install 'use-package))

(setq use-package-always-ensure t       ; 自动安装软件包
      use-package-expand-minimally t    ; 禁用加载检查，简化加载过程
      use-package-compute-statistics t  ; 收集统计数据
      use-package-enable-imenu-support t) ; imenu 索引支持

(require 'use-package)

(provide 'init-use-package)

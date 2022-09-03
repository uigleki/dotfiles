;;; 按键绑定
;;
;; 使用模态编辑，使用李杀的飞键键位，但是飞键模式有问题，所以用兼容性超好的猫态编辑模式实现
;; 具体是加载飞键的函数，由猫态模式去调用

(require 'init-xah-fly-keys)            ; 李杀飞键
(require 'init-meow)                    ; 猫态编辑

(provide 'init-keymap)

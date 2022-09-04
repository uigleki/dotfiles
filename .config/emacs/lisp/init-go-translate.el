;;; 语言翻译

(use-package go-translate
  ;; :bind
  ;; (:map mode-specific-map
  ;;       ("t" . gts-do-translate))
  :custom
  (gts-translate-list '(("en" "zh")))   ; 翻译语言对
  :config
  (setq gts-default-translator
        (gts-translator
         :picker (gts-noprompt-picker)  ; 用于拾取初始文本
         :engines (list                 ; 翻译引擎
                   (gts-bing-engine)
                   (gts-google-engine))
         :render (gts-buffer-render)))) ; 渲染器，用于输出结果到指定目标

(provide 'init-go-translate)

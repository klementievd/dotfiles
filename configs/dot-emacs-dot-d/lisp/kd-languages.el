;;; Comment:
;;
;; For finding specific language configuration you can
;; use `consult-line'. Just type ";;;" and get things like
;; Comment, Code, Rust, C/C++, CMake and e.t.c.
;;
;;; Code:

;;; Rust:
(defun kd/rust-mode-hook ()
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (add-hook 'before-save-hook 'lsp-format-buffer nil t))

(use-package rust-mode
  :ensure nil
  :hook (rust-mode . eglot-ensure)
  :custom
  (lsp-eldoc-hook nil)
  (lsp-enable-symbol-highlighting nil)
  (lsp-signature-auto-activate nil)
  (rust-format-on-save t))

;;; C/C++:
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-or-c++-mode 'eglot-ensure)

;;; CMake:
(use-package cmake-mode
  :ensure nil
  :mode ("CMakeLists.txt\\'"
	 "\\.cmake\\'")
  :hook (cmake-mode . eglot-ensure))

;;; Toml:
(use-package toml-mode
  :ensure nil
  :mode "\\.toml\\'")

;;; Yaml:
(use-package yaml-mode
  :ensure nil
  :mode ("\\.yaml\\'"
	 "\\.yml\\'"))

;;; Python:
(use-package python-mode
  :ensure nil
  :mode ("\\.py\\'")
  :hook (python-mode . eglot-ensure))

;;; Zig:
(use-package zig-mode
  :ensure nil
  :mode ("\\.zig\\'")
  :hook (zig-mode . eglot-ensure))

;;; GDScript:
(use-package gdscript-mode
  :ensure nil
  :hook (gdscript-mode . eglot-ensure)
  :mode "\\.gd\\'"
  :custom
  (gdscript-eglot-version 4))

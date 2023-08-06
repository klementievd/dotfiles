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
  :hook (rust-mode . lsp-deferred)
  :custom
  (lsp-eldoc-hook nil)
  (lsp-enable-symbol-highlighting nil)
  (lsp-signature-auto-activate nil)
  (rust-format-on-save t))

;;; C/C++:
(add-hook 'c-mode-hook 'lsp-deferred)
(add-hook 'c++-mode-hook 'lsp-deferred)
(add-hook 'c-or-c++-mode 'lsp-deferred)

;;; CMake:
(use-package cmake-mode
  :ensure nil
  :mode ("CMakeLists.txt\\'"
	 "\\.cmake\\'")
  :hook (cmake-mode . lsp-deferred))

;;; Toml:
(use-package toml-mode
  :ensure nil
  :mode "\\.toml\\'")

;;; Yaml:
(use-package yaml-mode
  :ensure nil
  :mode ("\\.yaml\\'"
	 "\\.yml\\'"))

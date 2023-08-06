;;; init.el --- KDMacs initializer -*- lexical binding: t -*-
;;; Commentary:
;;
;; TODO
;;
;;; Code:

;; GNU Emacs minimum version
(let* ((minver "28.2"))
  (when (version< emacs-version minver)
    (error "Emacs v%s or higher is required" minver)))

;; Remove warnings at startup
(setq warning-minimum-level :emergency)

;; Display startup time function
(defun display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
	   (format "%.2f seconds"
		   (float-time
		    (time-subtract after-init-time before-init-time)))
	   gcs-done))
(add-hook 'emacs-startup-hook #'display-startup-time)

;; Map `<escape>' to `quit'
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; GNU Emacas directories
(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))

;; For platform specific things
(setq *is-a-mac* (eq system-type 'darwin))
(setq *win64* (eq system-type 'windows-nt))
(setq *cygwin* (eq system-type 'cygwin))
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)))
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)))
(setq *emacs28* (>= emacs-major-version 28))

;; `emacs.d' `site-lisp' `lisp' directories definition
(defconst kd/emacs-d (file-name-as-directory user-emacs-directory)
  "Directory of emacs.d.")

(defconst kd/site-lisp-dir (concat kd/emacs-d "site-lisp")
  "Directory of site-lisp.")

(defconst kd/lisp-dir (concat kd/emacs-d "lisp")
  "Directory of personal configuration.")

(defconst kd/packages-load-path (concat kd/lisp-dir "/kd"))

;; Load lisp file from `kd/lisp-dir'
(defun kd/load-lisp-file (file)
  "Load FILE "
  (load (file-truename (format "%s/%s" kd/lisp-dir file)) t t))

(defun kd/add-subdirs-to-load-path (lisp-dir)
  "Add sub-directories under LISP-DIR into `load-path'."
  (let* ((default-directory lisp-dir))
    (setq load-path
          (append
           (delq nil
                 (mapcar (lambda (dir)
                           (unless (string-match "^\\." dir)
                             (expand-file-name dir)))
                         (directory-files lisp-dir)))
           load-path))))

;; Loading files
(let (;; PERF: Just a little performance increasing
      (file-name-handler-alist nil))
  (kd/load-lisp-file "kd-utils.el")       ; Utilities. Requiring `use-package', `on.el'
  (kd/load-lisp-file "kd-ui.el")          ; UI elements. Themes, fonts, e.t.c.
  (kd/load-lisp-file "kd-editor.el")      ; Editor elements. `evil-mode', `general', e.t.c.
  (kd/load-lisp-file "kd-completion.el")  ; Completion.
  (kd/load-lisp-file "kd-lsp.el")         ; LSP setup
  (kd/load-lisp-file "kd-languages.el")   ; All specific languages configurations
  (kd/load-lisp-file "kd-keybindings.el") ; Keybindings with general, which-key and hydra

  ;; KDMacs built-in packages:
  ;;
  ;; - Application launcher
  ;;
  (use-package app-launcher
    :ensure nil
    :load-path kd/packages-load-path
    :commands (kd/app-launcher)
    :bind (("C-c SPC" . kd/app-launcher))
    :custom
    (kd/app-launcher/excludes nil)))

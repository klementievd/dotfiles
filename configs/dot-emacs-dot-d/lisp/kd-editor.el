;;; kd-editor.el --- KDMacs editor setup -*- lexical binding: t -*-
;;; Commentary:
;;
;; TODO
;;
;;; Code:

(fset 'yes-or-no-p 'y-or-n-p)

(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.kdmacs-saves/"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

;; Scrolling settings
(setq scroll-step               1)
(setq scroll-margin            10)
(setq scroll-conservatively 10000)

(use-package evil
  :ensure nil
  ;; :disabled
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-want-C-i-jump nil)
  :bind (:map evil-insert-state-map
	      ;; "C-g" == "Esc"
	      ("C-g" . evil-normal-state)
	      ;; "C-h" == "Backspace"
	      ("C-h" . evil-delete-backward-char-and-join))
  :init
  (evil-mode 1)
  :config
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-escape
  :ensure nil
  :after evil
  :config (evil-escape-mode 1)
  :custom
  ;; "jk" == "Esc"
  (evil-escape-key-sequence "jk")
  ;; This is a default value
  (evil-escape-delay 0.1))

;; I use this with Emacs keybindings too
(use-package evil-nerd-commenter
  :ensure nil
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package evil-collection
  :ensure nil
  :after evil
  :config
  (evil-collection-init))

(use-package vertico
  :ensure nil
  :bind (:map vertico-map
	      ("C-h" . delete-backward-char)
	      ("C-l" . vertico-exit)
	      ("C-j" . vertico-next)
	      ("C-k" . vertico-previous))
  :init
  (vertico-mode))

(use-package consult
  :ensure nil
  :bind (("C-M-j" . consult-buffer)
	 ("C-s" . consult-line)))

;;; Comment:
;;
;; Keybindings
;;
;;; Code:

;; Leader keys
(kd/leader-keys
  "t" '(:ignore t :which-key "Toggles")
  "tt" '(consult-theme :which-key "Choose theme")
  "ts" '(hydra-text-scale/body :which-key "Scale text")
  "g" '((lambda ()
	  (interactive)
	  (if (executable-find "rg")
	      (consult-ripgrep)
	    (consult-grep)))
	:which-key "Find in files")
  "b" '(consult-buffer :which-key "Switch to buffer")
  "i" '(consult-imenu :which-key "Imenu")
  "f" '(consult-find :which-key "Find files")
  "s" '(consult-line :which-key "Go to line")
  "v" '(:ignore t :which-key "Version Control")
  "d" '(neotree-toggle :which-key "Directories tree view")
  "vg" '(magit :which-key "Magit")
  "m" '(:ignore t :which-key "Modes/Menus")
  "mg" '(guix :which-key "Guix pop-up menu"))


(defun kd/evil-dired-setup ()
  (evil-define-key 'normal dired-mode-map (kbd "SPC") 'dired-goto-file)
  (evil-define-key 'normal dired-mode-map (kbd "e") 'dired-up-directory)
  (kd/keep-only-normal-evil-state dired-mode-map))

(add-hook 'dired-mode-hook #'kd/evil-dired-setup)

(which-key-add-key-based-replacements
  "C-c SPC" "Application launcher"
  "C-c r" "Reload Emacs configuration")

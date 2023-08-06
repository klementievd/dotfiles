;;; Comment:
;;
;; Keybindings
;;
;;; Code:

(defhydra hydra-text-scale (:timeout 4)
  "Scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

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
  "s" '(consult-line :which-key "Go to line"))

(which-key-add-key-based-replacements
  "C-c SPC" "Application launcher"
  "C-c r" "Reload Emacs configuration")

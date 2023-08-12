;;; kd-utils.el --- KDMacs utilities -*- lexical binding: t -*-
;;; Commentary:
;;
;; TODO
;;
;;; Code

;; Separated from `use-package'
(electric-pair-mode)

;; Reload Emacs configuration
;; ISSUE ON GUIX:
;; I use Guix for dotfiles management. And `.emacs.d' symlinked
;; to my home directory. If I change my configuration, symlink isn't
;; changed and reloading don't do anything.
(defun kd/reload-emacs ()
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "C-c r") #'kd/reload-emacs)

(require 'use-package)
(require 'on)

(use-package org
  :ensure nil
  :commands (org-capture org-agenda)
  :hook (org-mode . org-indent-mode)
  :custom
  (org-ellipsis " ▾")
  (org-agenda-start-with-log-mode t)
  (org-log-done t)
  (org-log-into-drawer t)

  (org-agenda-files
   '("~/Projects/OrgFiles/Tasks.org"))

  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
     (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (org-refile-targets
   '(("Archive.org" :maxlevel . 1)
     ("Tasks.org" :maxlevel . 1)))

  (org-tag-alist
   '((:startgroup)
     ;; Put mutually exclusive tags here
     (:endgroup)
     ("@errand" . ?E)
     ("@home" . ?H)
     ("@work" . ?W)
     ("agenda" . ?a)
     ("planning" . ?p)
     ("publish" . ?P)
     ("batch" . ?b)
     ("note" . ?n)
     ("idea" . ?i)))

  ;; Configure custom agenda views
  (org-agenda-custom-commands
   '(("d" "Dashboard"
      ((agenda "" ((org-deadline-warning-days 7)))
       (todo "NEXT"
             ((org-agenda-overriding-header "Next Tasks")))
       (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))
     
     ("n" "Next Tasks"
      ((todo "NEXT"
             ((org-agenda-overriding-header "Next Tasks")))))
     
     ("W" "Work Tasks" tags-todo "+work-email")
     
     ;; Low-effort next actions
     ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
      ((org-agenda-overriding-header "Low Effort Tasks")
       (org-agenda-max-todos 20)
       (org-agenda-files org-agenda-files)))
     
     ("w" "Workflow Status"
      ((todo "WAIT"
             ((org-agenda-overriding-header "Waiting on External")
              (org-agenda-files org-agenda-files)))
       (todo "REVIEW"
             ((org-agenda-overriding-header "In Review")
              (org-agenda-files org-agenda-files)))
       (todo "PLAN"
             ((org-agenda-overriding-header "In Planning")
              (org-agenda-todo-list-sublevels nil)
              (org-agenda-files org-agenda-files)))
       (todo "BACKLOG"
             ((org-agenda-overriding-header "Project Backlog")
              (org-agenda-todo-list-sublevels nil)
              (org-agenda-files org-agenda-files)))
       (todo "READY"
             ((org-agenda-overriding-header "Ready for Work")
              (org-agenda-files org-agenda-files)))
       (todo "ACTIVE"
             ((org-agenda-overriding-header "Active Projects")
              (org-agenda-files org-agenda-files)))
       (todo "COMPLETED"
             ((org-agenda-overriding-header "Completed Projects")
              (org-agenda-files org-agenda-files)))
       (todo "CANC"
             ((org-agenda-overriding-header "Cancelled Projects")
              (org-agenda-files org-agenda-files)))))))

  (org-capture-templates
   `(("t" "Tasks / Projects")
     ("tt" "Task" entry (file+olp "~/Projects/Code/emacs-from-scratch/OrgFiles/Tasks.org" "Inbox")
      "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
     
     ("j" "Journal Entries")
     ("jj" "Journal" entry
      (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
      "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
      ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
      :clock-in :clock-resume
      :empty-lines 1)
     ("jm" "Meeting" entry
      (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
      "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
      :clock-in :clock-resume
      :empty-lines 1)
     
     ("w" "Workflows")
     ("we" "Checking Email" entry (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
      "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)
     
     ("m" "Metrics Capture")
     ("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
      "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  :config
  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj"))))

;; Use `vterm' only if you need terminal ui
(use-package vterm
  :ensure nil
  :commands vterm
  :bind (:map vterm-mode-map
	      ;; Switch buffer in vterm mode
	      ("C-M-j" . consult-buffer))
  :custom
  (vterm-timer-delay 0.01)
  (vterm-max-scrollback 10000))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(use-package which-key
  :ensure nil
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  :custom
  (which-key-idle-delay 1))

(use-package general
  :ensure nil
  :after evil
  :config
  (general-create-definer kd/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package hydra
  :ensure nil
  :defer t)

(use-package guix
  :ensure nil
  :commands (guix))

(use-package neotree
  :ensure nil
  :commands (neotree-toggle)
  :custom
  ;; Values:
  ;; * classic - with icons
  ;; * ascii - only ASCII symbols
  ;; * arrow - use unicode symbols
  ;; * nerd - use nerdtree identation mode and arrow
  (neo-theme 'ascii))

(use-package magit
  :ensure nil
  :defer t)

(defun kd/keep-only-normal-evil-state (mode)
  "Keep only `normal' evil state in MODE"
  (evil-define-key 'normal mode (kbd "i") (lambda () (interactive) (message "Hello, Evil Emacs!")))
  (evil-define-key 'normal mode (kbd "v") (lambda () (interactive) (message "Hello, Evil Emacs!")))
  (evil-define-key 'normal mode (kbd "C-v") (lambda () (interactive) (message "Hello, Evil Emacs!")))
  (evil-define-key 'normal mode (kbd "C-V") (lambda () (interactive) (message "Hello, Evil Emacs!")))
  (evil-define-key 'normal mode (kbd "V") (lambda () (interactive) (message "Hello, Evil Emacs!"))))

(defvar-local kd/hidden-mode-line-mode nil)

(define-minor-mode kd/hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global t
  :variable kd/hidden-mode-line-mode
  :group 'editing-basics
  (if kd/hidden-mode-line-mode
      (setq hide-mode-line mode-line-format
            mode-line-format nil)
    (setq mode-line-format hide-mode-line
          hide-mode-line nil))
  (force-mode-line-update)
  ;; Apparently force-mode-line-update is not always enough to
  ;; redisplay the mode-line
  (redraw-display)
  (when (and (called-interactively-p 'interactive)
             kd/hidden-mode-line-mode)
    (run-with-idle-timer
     0 nil 'message
     (concat "Hidden Mode Line Mode enabled.  "
             "Use M-x kd/hidden-mode-line-mode to make the mode-line appear."))))

(use-package emacs
  :ensure nil
  :hook (;; Don't display line numbers
	 ((org-mode
	   term-mode
	   shell-mode
	   treemacs-mode
	   dired-mode
	   vterm-mode
	   eshell-mode
	   telega-root-mode
	   telega-chat-mode
	   telega-image-mode
	   telega-patrons-mode
	   telega-webpage-mode
	   telega-autoplay-mode
	   telega-edit-file-mode
	   telega-mode-line-mode
	   telega-my-location-mode
	   telega-voip-sounds-mode
	   telega-appindicator-mode
	   telega-notifications-mode
	   telega-auto-translate-mode
	   telega-highlight-text-mode
	   telega-root-auto-fill-mode
	   telega-squash-message-mode
	   telega-active-locations-mode
	   telega-recognize-voice-message-mode) . (lambda () (display-line-numbers-mode 0)))
	 
	 ;; Hide mode line
	 ((term-mode
	   shell-mode
	   vterm-mode
	   eshell-mode) . (lambda () (kd/hidden-mode-line-mode))))
  :config
  ;; Unneeded UI elements
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (set-fringe-mode 10)
  (menu-bar-mode -1)

  (add-to-list 'default-frame-alist '(fullscreen . maximized))

  ;; Column/Line numbers
  (column-number-mode)
  (global-display-line-numbers-mode t)
  (setq-default display-line-numbers-type 'relative)

  ;; Fonts
  (set-face-attribute 'default nil :font "Fira Code" :height 90)
  (set-face-attribute 'fixed-pitch nil :font "Fira Code" :height 90)
  (set-face-attribute 'variable-pitch nil :font "Fira Code" :height 90)
  
  :custom
  ;; Unneeded UI elements
  (visible-bell nil)
  (inhibit-startup-message t))

;; Simple black theme
(use-package doom-themes
  :ensure nil
  :config
  ;; Good themes:
  ;; * doom-peacock
  ;; * doom-solarized-dark
  ;; * doom-dark+
  (load-theme 'doom-dark+ t))

;; Icons
(use-package all-the-icons
  :ensure nil)

;; Good modeline
(use-package doom-modeline
  :ensure nil
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 30))

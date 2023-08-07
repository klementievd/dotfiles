;;; Comment:
;;
;; My telega.el configuration
;;
;;; Code:

(use-package telega
  :ensure nil
  :defer t
  :commands (telega)
  :config
  ;; Enable notifications
  (telega-notifications-mode))

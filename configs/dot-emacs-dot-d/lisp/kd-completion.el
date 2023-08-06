(use-package company
  :ensure nil
  :hook (on-first-input . global-company-mode)
  :bind (:map company-active-map
	      ("<tab>" . company-complete-selection)
	      ("C-e" . company-abort))
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.1))

(use-package company-box
  :ensure nil
  :disabled t
  :hook (company-mode . company-box-mode))

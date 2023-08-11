(define-module (my-packages kdmacs)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages web)
  #:use-module (gnu packages bittorrent))

(define-public kdmacs
  (package
   (inherit emacs)
   (name "kdmacs")
   (propagated-inputs
    `(("font-abattis-cantarell" ,font-abattis-cantarell)
      ("font-fira-code" ,font-fira-code)
      ("emacs-all-the-icons" ,emacs-all-the-icons)
      
      ("lighttpd" ,lighttpd)
      ("rtorrent" ,rtorrent)

      ("emacs-neotree" ,emacs-neotree) ; Folder tree view for Emacs

      ("emacs-guix" ,emacs-guix) ; Emacs Guix integration
      
      ("emacs-telega" ,emacs-telega) ; Telegram client
      ("emacs-ement" ,emacs-ement) ; Matrix client

      ("emacs-use-package" ,emacs-use-package)

      ("emacs-evil" ,emacs-evil)
      ("emacs-evil-collection" ,emacs-evil-collection)
      ("emacs-evil-escape" ,emacs-evil-escape)
      ("emacs-evil-nerd-commenter" ,emacs-evil-nerd-commenter)

      ("emacs-vterm" ,emacs-vterm)
      ("emacs-magit" ,emacs-magit)
      ("emacs-org" ,emacs-org)

      ("emacs-rainbow-delimiters" ,emacs-rainbow-delimiters)

      ("emacs-lsp-mode" ,emacs-lsp-mode)
      ("emacs-company" ,emacs-company)
      ("emacs-company-box" ,emacs-company-box)
      ("emacs-lsp-ui" ,emacs-lsp-ui)
      ("emacs-lsp-treemacs" ,emacs-lsp-treemacs)

      ("emacs-consult" ,emacs-consult)
      ("emacs-vertico" ,emacs-vertico)

      ("emacs-general" ,emacs-general)
      ("emacs-hydra" ,emacs-hydra)
      ("emacs-which-key" ,emacs-which-key)
      ("emacs-helpful" ,emacs-helpful)

      ("emacs-all-the-icons" ,emacs-all-the-icons)
      ("emacs-doom-modeline" ,emacs-doom-modeline)

      ("emacs-on" ,emacs-on) ; Hooks for speedup

      ("emacs-rust-mode" ,emacs-rust-mode)
      ("emacs-cmake-mode" ,emacs-cmake-mode)
      ("emacs-toml-mode" ,emacs-toml-mode)
      ("emacs-yaml-mode" ,emacs-yaml-mode)
      
      ("emacs-mentor" ,emacs-mentor) ; Rtorrent client

      ("emacs-doom-themes" ,emacs-doom-themes)))
   (replacement emacs)))

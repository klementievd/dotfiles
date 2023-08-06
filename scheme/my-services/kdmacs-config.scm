(define-module (my-services kdmacs-config)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu services))

(define-public kdmacs-config
  (simple-service 'kdmacs-config
		  home-files-service-type
		  `((".emacs.d/lisp"
		     ,(local-file
		       "../../configs/dot-emacs-dot-d/lisp"
		       #:recursive? #t))
		    (".emacs.d/init.el"
		     ,(local-file
		       "../../configs/dot-emacs-dot-d/init.el"))
		    (".emacs.d/early-init.el"
		     ,(local-file
		       "../../configs/dot-emacs-dot-d/early-init.el")))))

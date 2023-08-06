(define-module (my-services guix-config)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu services))

(define-public guix-config
  (simple-service 'guix-config
		  home-files-service-type
		  `((".config/guix/channels.scm"
		     ,(local-file
		       "../../channels.scm")))))

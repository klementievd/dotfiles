(define-module (my-services git-config)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu services))

(define-public git-config
  (simple-service 'git-config
		  home-files-service-type
		  `((".gitconfig"
		    ,(local-file
		      "../../configs/dot-gitconfig")))))

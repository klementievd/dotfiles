(define-module (my-services lighttpd-service)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages web)
  #:use-module (guix gexp))

(define lighttpd-shepherd-service
  (shepherd-service
   (documentation "Run the lighttpd for rtorrent and emacs-mentor")
   (provision '(lighttpd))
   (requirement '(user-processes))
   (start #~(make-forkexec-constructor
	     (list #$(file-append lighttpd "/sbin/lighttpd")
		   "-D" "-f" "~/rtorrent-lighttpd.conf")
	     #:pid-file "/var/run/lighttpd.pid"))
   (stop #~(make-kill-destructor))))

(define-public lighttpd-service
  (simple-service 'lighttpd-service
		  home-shepherd-service-type
		  (home-shepherd-configuration
		   (services (list
			      lighttpd-shepherd-service)))))

(define-module (my-services rtorrent-config)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu services))

(define-public rtorrent-config
  (simple-service 'rtorrent-config
		  home-files-service-type
		  `(("rtorrent-lighttpd.conf"
		     ,(local-file
		       "../../configs/rtorrent-lighttpd.conf"))
		    (".rtorrent.rc"
		     ,(local-file
		       "../../configs/dot-rtorrent-dot-rc")))))

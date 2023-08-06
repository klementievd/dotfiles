;;; Commentary:
;;
;; Main Guix home configuration
;;
;; Currently I use it on my Fedora system
;;
;;; Code:

(use-modules (gnu home)

	     ;; Packages
	     (my-packages kdmacs)
	     (my-packages firefox-bin)

	     ;; Services
	     (my-services lighttpd-service)
	     (my-services rtorrent-config)
	     (my-services kdmacs-config)
	     (my-services git-config)
	     (my-services guix-config))

(home-environment
 (packages (list kdmacs
		 firefox-bin))

 (services (list
	    ;; lighttpd-service
	    rtorrent-config
	    guix-config
	    kdmacs-config
	    git-config)))

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
	     (gnu packages game-development)

	     ;; Services
	     (my-services kdmacs-config)
	     (my-services git-config)
	     (my-services guix-config))

(home-environment
 (packages (list kdmacs
		 firefox-bin
		 godot))

 (services (list
	    guix-config
	    kdmacs-config
	    git-config)))

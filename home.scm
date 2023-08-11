;;; Commentary:
;;
;; Main Guix home configuration
;;
;; Currently I use it on my Fedora system
;;
;; Some useful links:
;; @see https://www.reddit.com/r/linuxquestions/comments/a5lfpb/lightweight_alternative_for_libreoffice_writer/
;; @see https://www.reddit.com/r/WeAreTheMusicMakers/comments/20t1j7/im_looking_for_a_decent_open_source_alternative/
;; @see https://pandoc.org/
;; @see https://www.makeuseof.com/tag/5-photoshop-alternatives-can-run-linux/
;;
;;; Code:

(use-modules (gnu home)

	     ;; Packages
	     (my-packages kdmacs)
	     (my-packages firefox-bin)
	     (gnu packages gimp)
	     (gnu packages web-browsers)
	     (gnu packages kde)
	     (gnu packages audio)
	     (gnu packages music)
	     (gnu packages video)
	     (gnu packages graphics)
	     (gnu packages game-development)

	     ;; Services
	     (my-services kdmacs-config)
	     (my-services git-config)
	     (my-services guix-config))

(home-environment
 (packages (list kdmacs ; My Emacs

		 ;; Web
		 firefox-bin
		 qutebrowser

		 ;; Audio/Music
		 qsynth
		 rosegarden
		 hydrogen
		 ardour
		 audacity

		 ;; Graphics
		 gimp
		 blender

		 ;; Video
		 kdenlive
		 obs

		 ;; Game Development
		 godot))

 (services (list
	    guix-config
	    kdmacs-config
	    git-config)))

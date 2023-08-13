;;; Comment:
;;
;; Guix channels configuration.
;;
;;; Code:

(define (local-channel path)
  (string-append "file://" (getenv "SCRIPT_DIR")
		 "/" path))

(cons* (channel
	(name 'rde)
	(url "https://git.sr.ht/~abcdw/rde"))
       (channel
	(name 'nonguix)
	(url "https://gitlab.com/nonguix/nonguix.git"))
       (channel
	(name 'flat)
	(url "https://github.com/flatwhatson/guix-channel.git"))
       (channel
	(name 'guix-gaming-games)
	(url "https://gitlab.com/guix-gaming-channels/games.git"))
       (channel
	(name 'klementievd)
	(branch "dev")
	(url (local-channel "klementievd")))
       %default-channels)

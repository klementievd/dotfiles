;;; Comment:
;;
;; My GuixSD configuration.
;;
;; Current version used by me only for work. I don't play in
;; any games from Steam or other clients. I can play in
;; little open source games when compile smth or other boring processes
;;
;; This system can be used from USB drive. I have manual for this
;; because I use it one like installer or live system
;; 
;;; Code:

(define-module (my-default-os)
  ;; Base
  #:use-module (gnu)
  
  ;; Kernel and Firmware
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)

  ;; Packages
  #:use-module (gnu packages)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages version-control)

  ;; Services
  #:use-module (gnu services)
  #:use-module (gnu services avahi)
  #:use-module (gnu services base)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop)
  #:use-module (gnu services networking)
  #:use-module (gnu services xorg))

(define-public my-default-os
  (operating-system
   ;; Kernel setup
   (kernel linux)
   (initrd microcode-initrd)
   (firmware (list linux-firmware))
   
   ;; Host setup
   (host-name "guix")
   (timezone "Etc/UTC")
   (locale "en_US.UTF-8")
   (keyboard-layout (keyboard-layout "us,ru"
				     #:options '("grp:win_space_toggle")))

   ;; Users
   (users (cons (user-account
		 (name "kd")
		 (comment "Klementiev Dmitry")
		 (group "users")
		 (supplementary-groups '("wheel"
					 "audio"
					 "video")))
		%base-user-accounts))
   
   ;; Bootloader configuration
   ;; (label (string-append "GNU Guix " (package-version guix)))
   (bootloader (bootloader-configuration
		(bootloader grub-efi-removable-bootloader)
		(targets '((file-system-label "ESP")))
		(keyboard-layout keyboard-layout)))

   ;; Packages
   (packages (cons
	      git
	      %base-packages))

   ;; Services
   (services (append (list (service dhcp-client-service-type)
			   (service avahi-service-type)
			   (service elogind-service-type)
			   (service dbus-root-service-type)
			   (service xorg-server-service-type
				    (xorg-configuration
				     (keyboard-layout keyboard-layout))))
		     (modify-services %base-services
				      (guix-service-type config =>
							 (guix-configuration
							  (inherit config)
							  (substitute-urls
							   (list "https://substitutes.nonguix.org"
								 "https://bordeaux.guix.gnu.org")))))))
   
   ;; FS
   (file-systems (list (file-system
			(mount-point "/boot/efi")
			(device (file-system-label "ESP"))
			(type "vfat"))
		       (file-system
			(mount-point "/")
			(device (file-system-label "ROOT"))
			(type "ext4"))
		       (file-system
			(mount-point "/data")
			(device (file-system-label "DATA"))
			(type "ext4"))))))

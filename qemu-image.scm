;;; Comment:
;;
;; TODO
;;
;;; Code:

;; Load my scheme configuration files
(use-modules (gnu image)
	     (my-default-os)
	     (gnu system image)
	     (guix gexp)
	     (ice-9 match))

(define MiB (expt 2 20))
(define GiB (* 1024 MiB))

;; (image
;;  ;; TODO: Change to compressed-qcow2(qemu) image
;;  (format 'disk-image)
;;  (operating-system my-default-os)
;;  (partitions
;;   (list
;;    (partition
;;     (size (* 1 GiB))
;;     (offset (* 1024 1024))
;;     (label "GNU-ESP")
;;     (file-system "vfat")
;;     (flags '(esp))
;;     (initializer (gexp initialize-efi-partition)))
;;    (partition
;;     (size (* 8 GiB))
;;     (label "DATA")
;;     (file-system "ext4")
;;     (initializer #~(lambda* (root . rest)
;; 			    (mkdir root)
;; 			    (call-with-output-file
;; 				(string-append root "/data")
;; 			      (lambda (port)
;; 				(format port "my-data"))))))
;;    (partition
;;     (size 'guess)
;;     (label "ROOT")
;;     (file-system "ext4")
;;     (flags '(boot))
;;     (initializer (gexp initialize-root-partition))))))

(define data
  (partition
   (size (* 50 MiB))
   (label "DATA")
   (file-system "ext4")
   (initializer #~(lambda* (root . rest)
                    (mkdir root)
                    (call-with-output-file
                        (string-append root "/data")
                      (lambda (port)
                        (format port "my-data")))))))

(image
 (inherit efi-disk-image)
 (operating-system my-default-os)
 (partitions
  (match (image-partitions efi-disk-image)
    ((esp root)
     (list esp data root)))))

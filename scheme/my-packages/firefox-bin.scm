(define-module (my-packages firefox-bin)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (guix download)
  #:use-module (guix build-system gnu))

(define-public firefox-bin
  (package
    (name "firefox-bin")
    (version "115.0.2")
    (source (origin
              (method url-fetch)
              (uri
	       (string-append
		"https://download-installer.cdn.mozilla.net/pub/firefox/releases/115.0.2/linux-x86_64/en-US/firefox-"
		version
		".tar.bz2"))
              (sha256 (base32 "02ya8ilpplmdibpnfp8s1z67qilqg5prk2wf7xfaixldg57xykwy"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
	 (delete 'configure)
	 (delete 'check)
	 (delete 'install)
         (replace 'unpack
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (src (string-append out "/src"))
		    (bin (string-append out "/bin")))
               (mkdir-p src)
               (invoke "tar" "-xf" (assoc-ref inputs "source") "-C" src))))
	 (replace 'build
		  (lambda* (#:key inputs outputs #:allow-other-keys)
			   (let* ((out (assoc-ref outputs "out"))
				  (src (string-append out "/src"))
				  (bin (string-append out "/bin"))
				  (binary-files (list "")))
			     (mkdir-p bin)
			     (invoke "ln" "-sf" (string-append src "/firefox/firefox") (string-append bin "/"))
			     )))
	 (replace 'patch-dot-desktop-files
		    (lambda* (#:key inputs outputs #:allow-other-keys)
			     (let* ((out (assoc-ref outputs "out"))
				    (bin (string-append out "/bin/firefox"))
				    (icon (string-append out "/src/firefox/browser/chrome/icons/default/default128.png"))
				    (path (string-append out "/share/applications/")))
			       (mkdir-p path)
			       (with-output-to-file (string-append path "firefox.desktop")
				 (lambda ()
				   (display
				    (string-append
				     "[Desktop Entry]\n"
				     "Name=Firefox\n"
				     "Exec=" bin "\n"
				     "Icon=" icon "\n"
				     "Type=Application\n"))))
			       )))
	 )))
    (inputs `(("glibc" ,glibc)))
    (native-inputs `(("tar" ,tar)))
    (home-page "https://www.mozilla.org/firefox/")
    (synopsis "Web browser")
    (description "Mozilla Firefox is a free and open-source web browser developed by the Mozilla Foundation.")
    (license mpl2.0)))

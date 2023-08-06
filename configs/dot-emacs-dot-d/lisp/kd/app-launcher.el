;;; Comment:
;;
;; Simple and good application launcher for Emacs. I use it only with
;; EXWM as window manager. But you can run apps with it on other
;; window managers or desktop environments.
;;
;;; Code:

(require 'xdg)
(require 'cl-seq)

(defcustom kd/app-launcher/apps-directories
  (mapcar (lambda (dir) (expand-file-name "applications" dir))
	  (cons (xdg-data-home)
		(xdg-data-dirs)))
  "Directories in which to search for applications (.desktop files)."
  :type '(repeat directory))

(defcustom kd/app-launcher/annotation-function #'kd/app-launcher/annotation-function-default
  "Define the function that genereate the annotation for each completion choices."
  :type 'function)

(defcustom kd/app-launcher/action-function #'kd/app-launcher/action-function-default
  "Define the function that is used to run the selected application."
  :type 'function)

(defcustom kd/app-launcher/excludes nil
  "Excluded applications"
  :type 'list)

(defvar kd/app-launcher--cache nil
  "Cache of desktop files data.")

(defvar kd/app-launcher--cache-timestamp nil
  "Time when we last updated the cached application list.")

(defvar kd/app-launcher--cached-files nil
  "List of cached desktop files.")

(defun kd/app-launcher/list-desktop-files ()
  "Return an alist of all Linux applications.
Each list entry is a pair of (desktop-name . desktop-file).
This function always returns its elements in a stable order."
  (let ((hash (make-hash-table :test #'equal))
	result)
    (dolist (dir kd/app-launcher/apps-directories)
      (when (file-exists-p dir)
	(let ((dir (file-name-as-directory dir)))
	  (dolist (file (directory-files-recursively dir ".*\\.desktop$"))
	    (let ((id (subst-char-in-string ?/ ?- (file-relative-name file dir))))
	      (when (and (not (gethash id hash)) (file-readable-p file) (not (member id kd/app-launcher/excludes)))
		(push (cons id file) result)
		(puthash id file hash)))))))
    result))

(defun kd/app-launcher/parse-files (files)
  "Parse the .desktop files to return usable informations."
  (let ((hash (make-hash-table :test #'equal)))
    (dolist (entry files hash)
      (let ((file (cdr entry)))
	(with-temp-buffer
	  (insert-file-contents file)
	  (goto-char (point-min))
	  (let ((start (re-search-forward "^\\[Desktop Entry\\] *$" nil t))
		(end (re-search-forward "^\\[" nil t))
		(visible t)
		name comment exec)
	    (catch 'break
	      (unless start
		(message "Warning: File %s has no [Desktop Entry] group" file)
		(throw 'break nil))

	      (goto-char start)
	      (when (re-search-forward "^\\(Hidden\\|NoDisplay\\) *= *\\(1\\|true\\) *$" end t)
		(setq visible nil))
	      (setq name (match-string 1))

	      (goto-char start)
	      (unless (re-search-forward "^Type *= *Application *$" end t)
		(throw 'break nil))
	      (setq name (match-string 1))

	      (goto-char start)
	      (unless (re-search-forward "^Name *= *\\(.+\\)$" end t)
		(push file counsel-linux-apps-faulty)
		(message "Warning: File %s has no Name" file)
		(throw 'break nil))
	      (setq name (match-string 1))

	      (goto-char start)
	      (when (re-search-forward "^Comment *= *\\(.+\\)$" end t)
		(setq comment (match-string 1)))

	      (goto-char start)
	      (unless (re-search-forward "^Exec *= *\\(.+\\)$" end t)
		;; Don't warn because this can technically be a valid desktop file.
		(throw 'break nil))
	      (setq exec (match-string 1))

	      (goto-char start)
	      (when (re-search-forward "^TryExec *= *\\(.+\\)$" end t)
		(let ((try-exec (match-string 1)))
		  (unless (locate-file try-exec exec-path nil #'file-executable-p)
		    (throw 'break nil))))

	      (goto-char start)
	      (when (re-search-forward "^Categories *= *\\(.+\\)$" end t)
		(setq category (match-string 1)))

	      (puthash name
		       (list (cons 'file file)
			     (cons 'exec exec)
			     (cons 'comment comment)
			     (cons 'visible visible)
			     (cons 'category category))
		       hash))))))))

(defun kd/app-launcher/list-apps ()
  "Return list of all Linux .desktop applications."
  (let* ((new-desktop-alist (kd/app-launcher/list-desktop-files))
	 (new-files (mapcar 'cdr new-desktop-alist)))
    (unless (and (equal new-files kd/app-launcher--cached-files)
		 (null (cl-find-if
			(lambda (file)
			  (time-less-p
			   kd/app-launcher--cache-timestamp
			   (nth 5 (file-attributes file))))
			new-files)))
      (setq kd/app-launcher--cache (kd/app-launcher/parse-files new-desktop-alist))
      (setq kd/app-launcher--cache-timestamp (current-time))
      (setq kd/app-launcher--cached-files new-files)))
  kd/app-launcher--cache)

(defun kd/app-launcher/annotation-function-default (choice)
  "Default function to annotate the completion choices."
  (let ((str (cdr (assq 'comment (gethash choice kd/app-launcher--cache)))))
    (when str (concat " - " (propertize str 'face 'completions-annotations)))))

(defun kd/app-launcher/action-function-default (selected)
  "Default function used to run the selected application."
  (let* ((exec (cdr (assq 'exec (gethash selected kd/app-launcher--cache))))
	 (command (let (result)
		    (dolist (chunk (split-string exec " ") result)
		      (unless (or (equal chunk "%U")
				  (equal chunk "%F")
				  (equal chunk "%u")
				  (equal chunk "%f"))
			(setq result (concat result chunk " ")))))))
    (call-process-shell-command command nil 0 nil)))

;;;###autoload
(defun kd/app-launcher (&optional arg)
  "Launch an application installed on your machine.
When ARG is non-nil, ignore NoDisplay property in *.desktop files."
  (interactive)
  (let* ((candidates (kd/app-launcher/list-apps))
	 (result (completing-read
		  "Run app: "
		  (lambda (str pred flag)
		    (if (eq flag 'metadata)
			'(metadata
			  (annotation-function . (lambda (choice)
						   (funcall
						    kd/app-launcher/annotation-function
						    choice))))
		      (complete-with-action flag candidates str pred)))
		  (lambda (x y)
		    (if arg
			t
		      (cdr (assq 'visible y))))
		  t nil 'app-launcher nil nil)))
    (funcall kd/app-launcher/action-function result)))

(global-set-key (kbd "C-c SPC") #'kd/app-launcher)

;; Provide the app-launcher feature
(provide 'app-launcher)

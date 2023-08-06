;;; early-init.el --- KDMacs universal bootstraper -*- lexical binding: t -*-
;;; Commentary:
;;
;; Before init.el
;;
;; Summary:
;; - Disable package.el
;; - Garbage collector setup
;; - Debug environment
;;
;;; Code:

(setq package-enable-at-startup nil)

(setq gc-cons-percentage 0.6)

;; PERF: Garbage collection is a big contributor to startup times. This fends it
;;   off, but will be reset later by `gcmh-mode'. Not resetting it later will
;;   cause stuttering/freezes.
(setq gc-cons-threshold most-positive-fixnum)

;; PERF: Don't use precious startup time checking mtime on elisp bytecode.
;;   Ensuring correctness is 'doom sync's job, not the interactive session's.
;;   Still, stale byte-code will cause *heavy* losses in startup efficiency.
(setq load-prefer-newer noninteractive)

;; UX: Respect DEBUG envvar as an alternative to --debug-init, and to make are
;;   startup sufficiently verbose from this point on.
(when (getenv-internal "DEBUG")
  (setq init-file-debug t
        debug-on-error t))

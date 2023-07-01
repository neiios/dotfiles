(setq package-enable-at-startup nil)

(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 8 1000 1000)
                  gc-cons-percentage 0.1)))
(setq read-process-output-max (* 1000 1000))

(setq native-comp-async-report-warnings-errors nil)
(setq byte-compile-warnings '(not obsolete))

(setq warning-suppress-log-types '((comp) (bytecomp)))
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-directory))))

(setq inhibit-startup-message t)
(setq use-dialog-box nil)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq default-frame-alist '((fullscreen . maximized)
                            (vertical-scroll-bars . nil)
                            (horizontal-scroll-bars . nil)))

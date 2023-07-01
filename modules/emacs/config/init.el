(defvar elpaca-installer-version 0.4)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
			      :ref nil
			      :files (:defaults (:exclude "extensions"))
			      :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
	(if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
		 ((zerop (call-process "git" nil buffer t "clone"
				       (plist-get order :repo) repo)))
		 ((zerop (call-process "git" nil buffer t "checkout"
				       (or (plist-get order :ref) "--"))))
		 (emacs (concat invocation-directory invocation-name))
		 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
				       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
		 ((require 'elpaca))
		 ((elpaca-generate-autoloads "elpaca" repo)))
	    (kill-buffer buffer)
	  (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t))

(elpaca-wait)

(use-package no-littering
  :demand t
  :config
  (setq user-emacs-directory (expand-file-name "~/.config/emacs"))

  (require 'recentf)
  (add-to-list 'recentf-exclude
	       (recentf-expand-file-name no-littering-var-directory))
  (add-to-list 'recentf-exclude
	       (recentf-expand-file-name no-littering-etc-directory))

  (setq auto-save-file-name-transforms
	`((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq custom-file (no-littering-expand-etc-file-name "custom.el")))

(use-package emacs
  :elpaca nil
  :config
  (set-default-coding-systems 'utf-8)
  (setq ring-bell-function #'ignore)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (column-number-mode)

  (setq mouse-autoselect-window t)
  (pixel-scroll-precision-mode)

  (global-unset-key (kbd "ESC ESC ESC"))
  (global-set-key (kbd "C-S-C") 'kill-ring-save)
  (global-set-key (kbd "C-S-V") 'yank)

  (save-place-mode)
  (savehist-mode)
  (setq global-auto-revert-non-file-buffers t)
  (global-auto-revert-mode)

  (when (display-graphic-p)
    (context-menu-mode))

  (delete-selection-mode)
  (electric-pair-mode)

  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "(%s/%s) "))

(use-package benchmark-init
  :config
  (defun custom/display-startup-time ()
    (message "Emacs loaded in %s with %d garbage collections."
	     (format "%.2f seconds"
		     (float-time
		      (time-subtract after-init-time before-init-time)))
	     gcs-done))

  (add-hook 'elpaca-after-init-hook #'custom/display-startup-time)
  (add-hook 'elpaca-after-init-hook 'benchmark-init/deactivate))

(use-package modus-themes
  :config
  (setq modus-themes-common-palette-overrides
	'((fringe unspecified)
	  (fg-line-number-inactive "gray50")
	  (fg-line-number-active fg-main)
	  (bg-line-number-inactive unspecified)
	  (bg-line-number-active unspecified)
	  (bg-region bg-lavender)
	  (fg-region unspecified)
	  (border-mode-line-active unspecified)
	  (border-mode-line-inactive unspecified)))

  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs t)

  (setq modus-themes-headings
	'((1 . (bold 1.8))
	  (2 . (bold 1.5))
	  (t . (bold 1.3)))))

(use-package spacious-padding
  :elpaca (spacious-padding
	   :host sourcehut
	   :repo "protesilaos/spacious-padding")
  :config (spacious-padding-mode))

(use-package auto-dark
  :config
  (setq auto-dark-light-theme 'modus-operandi
	auto-dark-dark-theme 'modus-vivendi)
  (auto-dark-mode))

(use-package adaptive-wrap
  :config
  (setq-default adaptive-wrap-extra-indent 4)
  (add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode)
  (global-visual-line-mode +1)
  (visual-line-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package emacs
  :elpaca nil
  :config
  (set-face-attribute 'default nil
                      :font "JetBrainsMono Nerd Font"
                      :height 110
                      :weight 'medium)
  (set-face-attribute 'variable-pitch nil
                      :font "Noto Sans"
                      :height 120
                      :weight 'medium)
  (set-face-attribute 'fixed-pitch nil
                      :font "JetBrainsMono Nerd Font"
                      :height 110
                      :weight 'medium))

(use-package helpful
  :bind (("C-h f" . helpful-callable)
	 ("C-h v" . helpful-variable)
	 ("C-h k" . helpful-key)
	 ("C-h x" . helpful-command)
	 ("C-c C-d" . helpful-at-point)
	 ("C-h F" . helpful-function)))

(use-package which-key
  :init
  (setq which-key-show-early-on-C-h t)
  :config
  (which-key-mode))

(use-package vertico
  :init (vertico-mode))

(use-package emacs
  :elpaca nil
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  (setq read-extended-command-predicate
        #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; (use-package vertico-multiform
;;   :after vertico
;;   :elpaca nil
;;   :load-path "elpaca/repos/vertico/extensions")

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

;; (use-package aggressive-indent
;;   :hook ((emacs-lisp-mode) . aggressive-indent-mode))

(use-package org-tempo
  :elpaca nil ; Technically org-tempo is not a package but an org module
  :config
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

  (defun custom/org-babel-tangle-config ()
    (when (string-equal (buffer-file-name)
                        (file-truename "~/.config/emacs/config.org"))
      (let ((org-confirm-babel-evaluate nil))
        (org-babel-tangle))))

  (add-hook 'org-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                        #'custom/org-babel-tangle-config))))

(use-package org-superstar
  :hook (org-mode . (lambda () (org-superstar-mode)))
  :config (setq org-startup-indented t))

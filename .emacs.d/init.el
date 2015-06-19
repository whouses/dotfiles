(defvar drot/emacs-directory (file-name-directory load-file-name)
  "Emacs root directory.")

(defvar drot/cache-directory (expand-file-name "cache" drot/emacs-directory)
  "This directory houses all cache files.")
(make-directory drot/cache-directory t)

(defvar drot/custom-file (expand-file-name "custom.el" drot/emacs-directory)
  "Store changes from the customize interface in the selected file.")

(defvar drot/el-get-directory (expand-file-name "el-get" drot/emacs-directory)
  "El-Get package manager directory")

(add-to-list 'load-path (expand-file-name "el-get" drot/el-get-directory))

(defvar drot/el-get-recipes-directory (expand-file-name "recipes" drot/emacs-directory)
  "El-Get package manager recipes directory")
(make-directory drot/el-get-recipes-directory t)

;; Bootstrap El-Get
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; Additional El-Get recipes directory
(add-to-list 'el-get-recipe-path drot/el-get-recipes-directory)

(defvar drot/package-list
  '(ace-window
    anzu
    color-theme-zenburn
    company-mode
    diminish
    el-get
    erc-hl-nicks
    expand-region
    helm
    helm-descbinds
    magit
    multiple-cursors
    paredit
    rainbow-delimiters
    undo-tree
    use-package
    volatile-highlights
    yasnippet)
  "A list of packages to be installed automatically.")

;; Ensure that packages are installed
(el-get 'sync drot/package-list)

;; Load use-package
(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

;; Disable unnecessary GUI elements
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; Show tooltips in the echo area
(tooltip-mode 0)

;; Disable cursor blinking
(blink-cursor-mode 0)

;; Show column number and buffer size on the modeline
(column-number-mode)
(size-indication-mode)

;; Indicate buffer boundaries and empty lines
(setq-default indicate-buffer-boundaries 'left
              indicate-empty-lines t)

;; Don't show the welcome messages
(setq inhibit-startup-screen t
      initial-scratch-message nil)

;; Answer y or n instead of yes or no at prompts
(fset 'yes-or-no-p 'y-or-n-p)

;; Show unfinished keystrokes early
(setq echo-keystrokes 0.1)

;; Ignore case on completion
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

;; Show minibuffer completion only on second failed attempt
(setq completion-auto-help 'lazy)

;; Enable recursive minibuffers
(setq enable-recursive-minibuffers t)

;; Enable all disabled commands
(setq disabled-command-function nil)

;; Use spaces instead of tabs and set default tab width
(setq-default indent-tabs-mode nil
              tab-width 4)

;; Increase default fill width
(setq-default fill-column 80)

;; Draw block cursor as wide as the glyph under it
(setq x-stretch-cursor t)

;; Mouse yank at point instead of click
(setq mouse-yank-at-point t)

;; Set fallback font
(set-fontset-font "fontset-default" nil
                  (font-spec :size 16 :name "Symbola"))

;; Do not save duplicates
(setq history-delete-duplicates t
      kill-do-not-save-duplicates t)

;; Configuration for backup files
(setq auto-save-file-name-transforms `((".*" ,drot/cache-directory t))
      auto-save-list-file-prefix (expand-file-name ".saves-" drot/cache-directory)
      backup-directory-alist `(("." . ,drot/cache-directory))
      version-control t
      kept-new-versions 2
      delete-old-versions t
      backup-by-copying t)

;; Display read-only buffers in view mode
(setq view-read-only t
      view-inhibit-help-message t)

;; Replace dabbrev-expand with hippie-expand
(bind-key "M-/" 'hippie-expand)

;; Allow scrolling with Isearch
(setq isearch-allow-scroll t)

;; Pretty lambdas
(global-prettify-symbols-mode)

;; Save minibuffer history
(use-package savehist
  :init
  (setq savehist-file (expand-file-name "saved-history" drot/cache-directory))
  (savehist-mode)
  :config
  (setq savehist-additional-variables '(search-ring
                                        regexp-search-ring
                                        file-name-history
                                        extended-command-history
                                        kill-ring)
        savehist-autosave-interval 60))

;; Save recent files list
(use-package recentf
  :init
  (setq recentf-save-file (expand-file-name "recent-files" drot/cache-directory))
  (recentf-mode)
  :config
  (setq recentf-max-saved-items 100
        recentf-max-menu-items 20))

;; Highlight matching parentheses
(use-package paren
  :init
  (show-paren-mode)
  :config
  (setq show-paren-delay 0))

;; Highlight regexps interactively
(use-package hi-lock
  :init
  (global-hi-lock-mode))

;; Remove text in active region if inserting text
(use-package delsel
  :init
  (delete-selection-mode))

;; Which function mode
(use-package which-func
  :init
  (which-function-mode)
  :config
  (setq which-func-unknown "n/a"))

;; Indicate minibuffer recursion depth
(use-package mb-depth
  :init
  (minibuffer-depth-indicate-mode))

;; Undo and redo the window configuration
(use-package winner
  :init
  (winner-mode))

;; Ispell configuration
(use-package ispell
  :config
  (setq ispell-program-name "aspell"
        ispell-extra-args '("--sug-mode=ultra")))

;; Fly Spell mode configuration
(use-package flyspell
  :init
  (add-hook 'text-mode-hook 'flyspell-mode)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  :config
  (unbind-key "C-." flyspell-mode-map))

;; Hide Show mode
(use-package hideshow
  :init
  (dolist (hook '(c-mode-common-hook
                  emacs-lisp-mode-hook
                  python-mode-hook))
    (add-hook hook 'hs-minor-mode)))

;; Electric pair mode
(use-package elec-pair
  :init
  (add-hook 'prog-mode-hook 'electric-pair-mode))

;; Regexp builder
(use-package re-builder
  :defer t
  :config
  (setq reb-re-syntax 'string))

;; Bookmarks save directory
(use-package bookmark
  :defer t
  :config
  (setq bookmark-default-file (expand-file-name "bookmarks" drot/cache-directory)
        bookmark-save-flag 1))

;; Eshell save directory
(use-package eshell
  :defer t
  :config
  (setq eshell-directory-name (expand-file-name "eshell" drot/cache-directory)))

;; Shell mode configuration
(use-package shell
  :defer t
  :config
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
  (add-hook 'shell-mode-hook 'compilation-shell-minor-mode))

;; Disable YASnippet in term mode
(use-package term
  :defer t
  :config
  (add-hook 'term-mode-hook (lambda ()
                              (yas-minor-mode 0))))

;; Use Unified diff format
(use-package diff
  :defer t
  :config
  (setq diff-switches "-u"))

;; Ediff window split
(use-package ediff
  :defer t
  :config
  (setq ediff-split-window-function 'split-window-horizontally
        ediff-window-setup-function 'ediff-setup-windows-plain))

;; Compilation configuration
(use-package compile
  :defer t
  :config
  (setq compilation-scroll-output 'first-error
        compilation-ask-about-save nil))

;; Display ANSI colors in the compilation buffer
(use-package ansi-color
  :defer t
  :config
  (defun drot/colorize-compilation-buffer ()
    (when (eq major-mode compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'drot/colorize-compilation-buffer))

;; CC mode configuration
(use-package cc-mode
  :defer t
  :config
  (defun drot/c-mode-hook ()
    "C mode setup"
    (unless (or (file-exists-p "makefile")
                (file-exists-p "Makefile"))
      (set (make-local-variable 'compile-command)
           (concat "gcc " (buffer-file-name) " -o "))))

  (defun drot/c++-mode-hook ()
    "C++ mode setup"
    (unless (or (file-exists-p "makefile")
                (file-exists-p "Makefile"))
      (set (make-local-variable 'compile-command)
           (concat "g++ " (buffer-file-name) " -o "))))

  (add-hook 'c-mode-hook 'drot/c-mode-hook)
  (add-hook 'c++-mode-hook 'drot/c++-mode-hook)
  (add-hook 'c-mode-common-hook 'auto-fill-mode)

  (setq c-basic-offset 4
        c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "stroustrup"))))

;; TRAMP configuration
(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "ssh"
        tramp-backup-directory-alist backup-directory-alist
        tramp-auto-save-directory drot/cache-directory))

;; Prevent GnuTLS warnings
(use-package gnutls
  :defer t
  :config
  (setq gnutls-min-prime-bits 1024))

;; Calendar configuration
(use-package calendar
  :defer t
  :config
  (setq calendar-mark-holidays-flag t
        holiday-general-holidays nil
        holiday-bahai-holidays nil
        holiday-oriental-holidays nil
        holiday-solar-holidays nil
        holiday-islamic-holidays nil
        holiday-hebrew-holidays nil
        calendar-date-style 'european
        calendar-latitude 43.20
        calendar-longitude 17.48
        calendar-location-name "Mostar, Bosnia and Herzegovina"))

;; Doc View mode configuration
(use-package doc-view
  :defer t
  :config
  (setq doc-view-resolution 300
        doc-view-continuous t))

;; Open URLs in Firefox
(use-package browse-url
  :defer t
  :config
  (setq browse-url-browser-function 'browse-url-firefox))

;; Remember point position in files
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saved-places" drot/cache-directory))
  (setq-default save-place t))

;; Load abbrevs and enable Abbrev Mode
(use-package abbrev
  :diminish "Abr"
  :config
  (setq abbrev-file-name (expand-file-name "abbrevs" drot/cache-directory)
        save-abbrevs t)
  (if (file-exists-p abbrev-file-name)
      (quietly-read-abbrev-file))
  (setq-default abbrev-mode t))

;; Color theme
(use-package zenburn-theme)

;; Ace-window
(use-package ace-window
  :defer t
  :config
  (setq aw-dispatch-always t)
  :bind ("C-č" . ace-window))

;; Anzu
(use-package anzu
  :diminish "AZ"
  :init
  (global-anzu-mode)
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp)))

;; Avy
(use-package avy
  :defer t
  :bind (("C-." . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("M-g g" . avy-goto-line)
         ("M-g w" . avy-goto-word-1)
         ("M-g e" . avy-goto-word-0)))

;; Company mode
(use-package company
  :diminish "co"
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :bind ("C-c y" . company-yasnippet)
  :config
  (setq company-echo-delay 0
        company-show-numbers t
        company-backends '(company-nxml
                           company-css
                           company-capf (company-dabbrev-code company-keywords)
                           company-files
                           company-dabbrev)))

;; Expand region
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; Magit
(use-package magit
  :defer t
  :init
  (setq magit-last-seen-setup-instructions "1.4.0"
        magit-auto-revert-mode nil))

;; Org-mode
(use-package org
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link))
  :config
  (setq org-log-done 'time
        org-src-fontify-natively t
        org-src-tab-acts-natively t))

;; ERC configuration
(use-package erc
  :defer t
  :init
  (defun irc ()
    "Connect to IRC."
    (interactive)
    (erc-tls :server "adams.freenode.net" :port 6697
             :nick "drot")
    (erc-tls :server "pine.forestnet.org" :port 6697
             :nick "drot"))
  :config
  (use-package erc-hl-nicks)
  (add-to-list 'erc-modules 'notifications)

  (setq erc-prompt-for-password nil
        erc-autojoin-channels-alist '(("freenode" "#debian" "#emacs")
                                      ("forestnet" "#reloaded" "#fo2"))
        erc-server-reconnect-timeout 10
        erc-truncate-buffer-on-save t
        erc-fill-function 'erc-fill-static
        erc-fill-column 155
        erc-fill-static-center 15
        erc-track-exclude-server-buffer t
        erc-track-showcount t
        erc-track-switch-direction 'importance
        erc-track-visibility 'selected-visible
        erc-insert-timestamp-function 'erc-insert-timestamp-left
        erc-timestamp-only-if-changed-flag nil
        erc-timestamp-format "[%H:%M] "
        erc-header-line-format "%t: %o"
        erc-interpret-mirc-color t
        erc-button-buttonize-nicks nil
        erc-format-nick-function 'erc-format-@nick
        erc-nick-uniquifier "_"
        erc-show-my-nick nil
        erc-prompt (lambda ()
                     (concat (buffer-name) ">")))

  (defun drot/erc-mode-hook ()
    "Keep prompt at bottom and disable Company and YASnippet in ERC buffers."
    (set (make-local-variable 'scroll-conservatively) 100)
    (company-mode 0)
    (yas-minor-mode 0))

  (add-hook 'erc-mode-hook 'drot/erc-mode-hook)
  (add-hook 'erc-insert-post-hook 'erc-truncate-buffer)
  (erc-spelling-mode))

;; Helm
(use-package helm
  :init
  (require 'helm-config)
  (helm-mode)
  (add-to-list 'helm-mode-no-completion-in-region-in-modes 'erc-mode)
  (setq helm-buffers-fuzzy-matching t
        helm-M-x-fuzzy-match t
        helm-apropos-fuzzy-match t
        helm-lisp-fuzzy-completion t
        helm-recentf-fuzzy-match t)
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-h a" . helm-apropos)
         ("C-x C-f" . helm-find-files)
         ("C-x C-b" . helm-buffers-list)
         ("C-x c o" . helm-occur)
         ("C-c i" . helm-imenu-in-all-buffers)
         ("C-c f" . helm-recentf)))

;; Helm describe bindings
(use-package helm-descbinds
  :defer t
  :bind ("C-h b" . helm-descbinds))

;; Multiple cursors
(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-*" . mc/mark-all-like-this)))

;; ParEdit
(use-package paredit
  :diminish "PE"
  :config
  (dolist (hook '(emacs-lisp-mode-hook
                  ielm-mode-hook
                  lisp-mode-hook
                  lisp-interaction-mode-hook
                  scheme-mode-hook))
    (add-hook hook 'paredit-mode))

  (defvar drot/paredit-minibuffer-commands '(eval-expression
                                             pp-eval-expression
                                             eval-expression-with-eldoc
                                             ibuffer-do-eval
                                             ibuffer-do-view-and-eval)
    "Interactive commands for which ParEdit should be enabled in the minibuffer.")

  (defun drot/paredit-minibuffer ()
    "Enable ParEdit during lisp-related minibuffer commands."
    (if (memq this-command drot/paredit-minibuffer-commands)
        (paredit-mode)))

  (add-hook 'minibuffer-setup-hook 'drot/paredit-minibuffer)

  (defun drot/paredit-slime-fix ()
    "Fix ParEdit conflict with SLIME."
    (define-key slime-repl-mode-map
      (read-kbd-macro paredit-backward-delete-key) nil))

  (add-hook 'slime-repl-mode-hook 'paredit-mode)
  (add-hook 'slime-repl-mode-hook 'drot/paredit-slime-fix)

  (add-hook 'paredit-mode-hook (lambda ()
                                 (electric-pair-mode 0))))

;; Show documentation with ElDoc mode
(use-package eldoc
  :diminish "ElD"
  :config
  (dolist (hook '(eval-expression-minibuffer-setup-hook
                  lisp-interaction-mode-hook
                  emacs-lisp-mode-hook
                  ielm-mode-hook))
    (add-hook hook 'eldoc-mode))
  (eldoc-add-command 'paredit-backward-delete
                     'paredit-close-round))

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; Volatile Highlights
(use-package volatile-highlights
  :config
  (volatile-highlights-mode))

;; YASnippet
(use-package yasnippet
  :init
  (make-directory "~/.emacs.d/snippets" t)
  :config
  (setq yas-verbosity 1)
  (yas-global-mode))

;; Undo Tree
(use-package undo-tree
  :diminish "UT"
  :config
  (setq undo-tree-history-directory-alist backup-directory-alist
        undo-tree-auto-save-history t)
  (global-undo-tree-mode))

;; Load changes from the customize interface
(setq custom-file drot/custom-file)
(when (file-exists-p drot/custom-file)
  (load drot/custom-file))

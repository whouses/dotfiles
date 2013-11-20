;;
;; my-defaults.el - Core Emacs configuration
;;

;; Store all backup and auto-save files in the tmp directory
(setq backup-directory-alist
      `((".*" . ,my-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,my-tmp-dir t)))
(setq auto-save-list-file-prefix my-tmp-dir)

;; Save minibuffer history
(setq savehist-additional-variables
      '(search-ring regexp-search-ring)
      savehist-autosave-interval 60
      savehist-file (expand-file-name "minbuf.hist" my-saves-dir))
(savehist-mode t)

;; Message buffer size
(setq message-log-max 1024)

;; Ignore case on completion
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

;; More useful apropos
(setq apropos-do-all t)

;; Enable all disabled commands
(setq disabled-command-function nil)

;; Enable X clipboard usage
(setq x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t)

;; Open URLs in the selected browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "conkeror")

;; Scroll compilation buffer to first error
(setq compilation-scroll-output 'first-error)

;; Ediff window placement
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

;; Use Unified diff format
(setq diff-switches "-u")

;; Make buffer names unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward
      uniquify-separator "/"
      uniquify-after-kill-buffer-p t
      uniquify-ignore-buffers-re "^\\*")

;; Bookmarks save directory
(require 'bookmark)
(setq bookmark-default-file (expand-file-name "bookmarks" my-saves-dir)
      bookmark-save-flag 1)

;; Remember point position in files
(require 'saveplace)
(setq save-place-file (expand-file-name "saved-places" my-saves-dir))
(setq-default save-place t)

;; Saner regex syntax
(require 're-builder)
(setq reb-re-syntax 'string)

;; TRAMP default file transfer method
(require 'tramp)
(setq tramp-default-method "ssh")

;; Eshell save directory
(require 'eshell)
(setq eshell-directory-name (expand-file-name "eshell" my-saves-dir))

;; Fly Spell mode configuration
(require 'flyspell)
(setq ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra")
      ispell-dictionary "english")

;; Doc View mode configuration
(require 'doc-view)
(setq doc-view-resolution 300
      doc-view-continuous t)

;; Use ANSI colors within shell-mode
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(provide 'my-defaults)
;; my-defaults.el ends here
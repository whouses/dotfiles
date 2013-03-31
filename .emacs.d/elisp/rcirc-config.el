; drot rcirc
(require 'rcirc)

; Connection
(setq rcirc-server-alist
      '(("irc.freenode.net" :channels ("#archlinux" "#emacs"))))

; Authorization
(load "~/.ircpass")
(setq rcirc-authinfo
      `(("freenode" nickserv "drot" ,freenode-password)))

; Max line width and number
(setq rcirc-fill-flag nil
      rcirc-buffer-maximum-lines 1024)

; Hide IRC spam
(setq rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY"))

; Keep prompt at bottom
(add-hook 'rcirc-mode-hook
	  (lambda ()
	    (set (make-local-variable 'scroll-conservatively)
		 8192)))

; Turn on spell checking
(add-hook 'rcirc-mode-hook (lambda ()
			     (flyspell-mode 1)))

; Turn on omit-mode
(add-hook 'rcirc-mode-hook '(lambda ()
			      (rcirc-omit-mode)))

; Track channel activity
(add-hook 'rcirc-mode-hook (lambda ()
			     (rcirc-track-minor-mode 1)))

(provide 'rcirc-config)

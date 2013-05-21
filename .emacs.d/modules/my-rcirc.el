;;
;; my-rcirc.el - rcirc IRC client configuration
;;

;; Load rcirc
(require 'rcirc)

; Connection
(setq rcirc-server-alist
      '(("adams.freenode.net" :channels ("#archlinux" "#emacs"))))

; Authorization
(if (file-exists-p "~/.ircpass")
    (load "~/.ircpass"))
(setq rcirc-authinfo
      `(("freenode" nickserv "drot" ,freenode-password)))

; Max line width and number
(setq rcirc-fill-flag nil
      rcirc-buffer-maximum-lines 1024)

; Hide IRC spam
(setq rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY"))

;; Wrap lines that are too long
(add-hook 'rcirc-mode-hook 'visual-line-mode)

; Turn on Fly Spell mode
(add-hook 'rcirc-mode-hook 'flyspell-mode)

; Turn on Omit mode
(add-hook 'rcirc-mode-hook 'rcirc-omit-mode)

; Track channel activity
(add-hook 'rcirc-mode-hook 'rcirc-track-minor-mode)

(provide 'my-rcirc)
;; my-rcirc.el ends here

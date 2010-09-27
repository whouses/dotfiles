;; look
(setq erc-nick-uniquifier "_"
      erc-notice-prefix "* "
      erc-prompt ">"
      erc-match-mode t
      erc-button-buttonize-nicks nil
      erc-kill-buffer-on-part t
      erc-server-auto-reconnect nil
      erc-kill-queries-on-quit t
      erc-kill-server-buffer-on-quit t
      erc-insert-timestamp-function 'erc-insert-timestamp-left
      erc-timestamp-format "%H:%M "
      erc-timestamp-only-if-changed-flag nil
      erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
				"324" "329" "332" "333" "353" "477")
      erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))

;; beeping
(add-hook 'erc-text-matched-hook 'erc-sound-if-not-server)
(defun erc-sound-if-not-server (match-type nickuserhost msg)
  (unless (string-match "Server:[0-9]+" nickuserhost)
    (start-process-shell-command "lolsound" nil "ossplay ~/.emacs.d/beep.wav")))

;; colors
(custom-set-faces
'(erc-notice-face ((t (:foreground "tomato" :weight normal))))
'(erc-error-face ((t (:foreground "tomato"))))
'(erc-input-face ((t (:foreground "dodger blue"))))
'(erc-button ((t (:background "#2e3434" :foreground "cyan" :underline "cyan" :weight normal))))
'(erc-my-nick-face ((t (:foreground "#edd400" :weight bold))))
'(erc-prompt-face ((t (:background "#2e3434" :foreground "#6ac214" :weight normal))))
'(erc-timestamp-face ((t (:foreground "cyan" :weight normal)))))

;; nick colors
(require 'erc-highlight-nicknames)
(add-to-list 'erc-modules 'highlight-nicknames)
(erc-update-modules)

;; dynamic fill width
(make-variable-buffer-local 'erc-fill-column)
(add-hook 'window-configuration-change-hook 
	  '(lambda ()
	     (save-excursion
	       (walk-windows
		(lambda (w)
		  (let ((buffer (window-buffer w)))
		    (set-buffer buffer)
		    (when (eq major-mode 'erc-mode)
		      (setq erc-fill-column (- (window-width w) 2)))))))))

;; Pool of colors to use when coloring IRC nicks.
(setq erc-colors-list '("#8d4a4a" "#ba5b34" "#96a62d"
			"#546a29" "#34676f"
			"#5c737c" "#7f355e"
			"#7e9960" "#385e6b"
			"#909737" "#953331"))

(defun erc-get-color-for-nick (nick)
  "Gets a color for NICK.  Hash the nick and use a random color from the pool"
  (nth
   (mod (string-to-number
         (substring (md5 (downcase nick)) 0 6) 16)
        (length erc-colors-list))
   erc-colors-list))

(defun erc-put-color-on-nick ()
  "Modifies the color of nicks according to erc-get-color-for-nick"
  (save-excursion
    (goto-char (point-min))
    (while (forward-word 1)
      (setq bounds (bounds-of-thing-at-point 'word))
      (setq word (buffer-substring-no-properties
                  (car bounds) (cdr bounds)))
      (when (or (and (erc-server-buffer-p) (erc-get-server-user word))
                (and erc-channel-users (erc-get-channel-user word)))
        (put-text-property (car bounds) (cdr bounds)
                           'face (cons 'foreground-color
                                       (erc-get-color-for-nick word)))))))

(add-hook 'erc-mode-hook (lambda ()
                           (modify-syntax-entry ?\_ "w" nil)
                           (modify-syntax-entry ?\- "w" nil)))

(add-hook 'erc-insert-modify-hook 'erc-put-color-on-nick)

(provide 'erc-nick-colors)

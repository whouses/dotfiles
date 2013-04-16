;;
;; drot-undo.el - Undo tree configuration
;;

;; Enable undo history
(setq undo-tree-auto-save-history t)

;; Store undo history in the tmp directory
(setq undo-tree-history-directory-alist
      `((".*" . ,temporary-file-directory)))

;; Enable Undo tree
(global-undo-tree-mode)

;; Shorten mode name
(diminish 'undo-tree-mode "UTr")

(provide 'drot-undo)
;; drot-undo.el ends here

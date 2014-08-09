(defconst drot/emacs-directory (file-name-directory load-file-name)
  "Emacs root directory.")

(defconst drot/bootstrap-file (expand-file-name "boot.org" drot/emacs-directory)
  "Emacs configuration file written and loaded with Org-mode")

(defconst drot/cache-directory (expand-file-name "cache" drot/emacs-directory)
  "This directory houses all cache files.")
(make-directory drot/cache-directory t)

(defconst drot/custom-file (expand-file-name "custom.el" drot/cache-directory)
  "Store changes from the customize interface in the selected file.")

(defconst drot/yas-directory (expand-file-name "snippets" drot/emacs-directory)
  "This directory houses all snippets.")
(make-directory drot/yas-directory t)

;; Package repository selection and activation
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/"))
      package-enable-at-startup nil)
(package-initialize)

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Load configuraton file with Org-mode
(org-babel-load-file drot/bootstrap-file)

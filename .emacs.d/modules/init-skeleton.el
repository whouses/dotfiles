;;; init-skeleton.el --- Skeleton Mode skeletons

;; Prevent skeleton/abbrev recursion
(setq skeleton-further-elements '((abbrev-mode nil)))

(define-skeleton my-cpp-skel
  "C++ skeleton"
  nil
  "#include <iostream>\n"
  "\n"
  "int main ()\n"
  "{\n"
  > _
  "\n"
  > "return 0;"
  "\n}")

(provide 'init-skeleton)

;;; init-skeleton.el ends here
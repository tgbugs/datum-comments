(in-package :datum-comments)

(defun datum-comment (stream char arg)
  (declare (ignore char arg))
  (let ((*read-suppress* t))
    (read-preserving-whitespace stream t nil t))
  (values))

(defun enable-datum-comments ()
  ;; any changes to datum-comment require this to be called again
  ;; because #'datum-comment is dereferenced by set-dispatch-macro-character
  (set-dispatch-macro-character #\# #\; #'datum-comment))

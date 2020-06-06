(in-package :datum-comments/test)

#+()
(this should hrm
      still indents correctly)

;; inline
#; (testing) (defparameter *test-value* "hahahah I am not commented out") #; but-i-am!

;; comments inbetween
#;
;; many
#| comments |#
;; inbetween
(but I am still commented out)

;; empty lines in between
#;

(by induction I AM FREEEEEEEEEEEEEEEE!)

;; nested
#;(test this should ;be ok right?)
   #; nothing )

;; nested for highlight testing
#;
(regular comments should be parsed as such ; this is a comment)
         this is the rest of the datum comment)

#;
(actually nested test without throwing in a regular comment
          #;
          (the nested sexp)
          this is also commented out)

;; symbol
#;
mauauauauauahahahaha

;; string
#;
"string"

;; number
#;
123123.1231

#; ; should be ignored
(hrm)

#; ; this is a comment that should work ... ?
(and now we have (datum comments in common lisp!)
     ;; and some more complexity
     (+ 2 3))

;; block
#|
#;
(nested inside one of these fellows)
|#

;; double, the racket behavior is as expected, comments are comments
#; ; help I'm
#; ; trapped in
(one fish) ; yay!
(two fish) ; woo!

(defun run-all-tests ()
  (princ "running tests, but if you got here then this was a success")
  (princ (format nil "~%got test value ~s~%~%" *test-value*))
  t)

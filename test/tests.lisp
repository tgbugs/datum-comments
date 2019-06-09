(in-package :datum-comments-test)

;; inline
#; (testing) (defparameter *test-value* "hahahah I am not commented out") #; but-i-am!

;; comments inbetween
#;
;; many
#| comments |#
;; inbetween
(but I am still commented out)


;; nested
#;(test this should ;be ok right?)
   #; nothing )

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

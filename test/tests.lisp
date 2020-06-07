(in-package :datum-comments/test)

(format t "testing ~a ~%" (lisp-implementation-type))

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

;; dealing with package names
#;
(package:name should be skipped and not cause an error)

(defvar *success* '())

#; wat: (push 1 *success*)
#; :wat (push 2 *success*)
#; wat:wat (push 3 *success*)

#;(other wat: darn) (push 4 *success*)
#;(other :wat crap) (push 5 *success*)
#;(other (wat:v-1) shoot) (push 6 *success*)
#;(other (wat:v0 nested) shoot) (push 7 *success*)

#;(other wat:v1) (push 8 *success*)
#;(wat:v2) (push 9 *success*)
#;(wat:v3 other) (push 10 *success*)

(defun run-all-tests ()
  (let* ((max 10)
         (all (loop for n from 1 to max collect n))
         (eaten (set-difference all *success*))
         (was/were (if (= 1 (length eaten)) "were" "was")))
    (when eaten (error (format nil "~a ~a eaten!" eaten was/were))))
  (format t "running tests, but if you got here then this was a success")
  (format t "~%got test value ~s~%~%" *test-value*)
  t)

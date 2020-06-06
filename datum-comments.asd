(in-package :cl-user)

(defpackage :datum-comments-asd
  (:use :cl :asdf))

(in-package :datum-comments-asd)

(defsystem :datum-comments
  :version "0.0.1"
  :author "Tom Gillespie <tgbugs@gmail.com>"
  :license "Public Domain (Unlicense)"
  :description "datum #;(comments) for common lisp"
  :serial t  ; needed so that packages loads before the others
  :components ((:file "packages")
               (:file "read")
               (:file "enable"))
  :in-order-to ((test-op (test-op :datum-comments/test))))

(defsystem :datum-comments/test
  :depends-on (:datum-comments)
  :components ((:module "test"
                        :serial t
                        :components ((:file "packages")
                                     (:file "tests"))))
  :perform (test-op (o c) (uiop:symbol-call :datum-comments/test :run-all-tests)))

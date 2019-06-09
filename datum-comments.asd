(in-package :cl-user)

(defpackage :datum-comments-asd
  (:use :cl :asdf))

(in-package :datum-comments-asd)

(defsystem :datum-comments
  :version "0.0.1"
  :serial t  ; needed so that packages loads before the others
  :components ((:file "packages")
               (:file "read")
               (:file "enable")
               ))

(defsystem :datum-comments-test
  :depends-on (:datum-comments)
  :components ((:module "test"
                        :serial t
                        :components ((:file "packages")
                                     (:file "tests")))))


;; tell the system where to find
(defmethod perform ((o test-op) (c (eql (find-system :datum-comments))))
  (operate 'load-op :datum-comments-test)
  (funcall (intern (symbol-name :run-all-tests) (find-package :datum-comments-test))))

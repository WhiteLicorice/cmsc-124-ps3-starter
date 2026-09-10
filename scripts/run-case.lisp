;;;; run-case.lisp -- what ./run runs. It prints one case's four fields.

(let ((args ext:*args*))
  (unless (= (length args) 1)
    (format *error-output* "usage: ./run CASE_ID~%")
    (ext:exit 64))
  (ps3-load "cases/cases.lisp")
  (ps3-load "scripts/support.lisp")
  (let* ((case-id (first args))
         (description (handler-case (ps3-describe-case case-id)
                        (error (condition)
                          (format *error-output* "~a~%" condition)
                          (ext:exit 65)))))
    (format t "case: ~a~%" case-id)
    (loop for field in *ps3-fields*
          for answer in description
          do (format t "~a: ~a~%" field answer))))

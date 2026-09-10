;;;; lint-predictions.lisp -- what ./lint runs.
;;;;
;;;; It loads the kind and operator vocabularies from support.lisp and the form
;;;; checks from validate-predictions.lisp. It never opens tests/expected.tsv
;;;; and never evaluates a case.

(ps3-load "scripts/support.lisp")
(ps3-load "scripts/validate-predictions.lisp")

(let* ((report (ps3-validate-predictions "predictions.tsv"))
       (problems (first report))
       (todos (second report)))
  (when problems
    (format t "== form ==~%")
    (dolist (problem problems)
      (format t "  ~a~%" problem)))
  (when todos
    (when problems (format t "~%"))
    (format t "== unfinished ==~%")
    (dolist (todo todos)
      (format t "  ~a~%" todo)))
  (when (and (null problems) (null todos))
    (format t "predictions.tsv is well formed and complete.~%")
    (format t "This read the table's shape only. It says nothing about whether an answer is right.~%")
    (ext:exit 0))
  (format t "~%")
  (when problems
    (format t "Those are formatting faults, not wrong answers. Fix them first.~%"))
  (when todos
    (format t "Replace every TODO before you commit the table.~%"))
  (ext:exit 1))

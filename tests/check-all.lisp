;;;; check-all.lisp -- the complete public grader. This file is the whole
;;;; grade. Nothing is hidden and nothing else is run.

(ps3-load "cases/cases.lisp")
(ps3-load "scripts/support.lisp")
(ps3-load "scripts/validate-predictions.lisp")

(defun ps3-abort (format-string &rest arguments)
  "Stop before any check is scored. A run that ends without a == result ==
line never scored anything."
  (apply #'format *error-output* format-string arguments)
  (format *error-output* "~%")
  (ext:exit 1))

(defun ps3-read-table (path)
  (let ((lines (ps3-read-lines path)))
    (when (eq lines :missing)
      (ps3-abort "~a is missing." path))
    (when (null lines)
      (ps3-abort "~a is empty." path))
    (mapcar #'ps3-split-tab lines)))

;;; A form fault in predictions.tsv survives the parse and then fails its
;;; comparison, which reads like a wrong prediction rather than a stray space.
;;; Name the faults before scoring so nobody hunts for an evaluation rule they
;;; already understood. Only malformations are listed. A cell still reading
;;; TODO already shows as a failed check, and on a fresh starter every cell
;;; does.

(let ((problems (first (ps3-validate-predictions "predictions.tsv"))))
  (when problems
    (format t "== predictions.tsv form ==~%")
    (dolist (problem problems)
      (format t "  ~a~%" problem))
    (format t "~%Those are formatting faults, not wrong answers.")
    (format t " Run ./lint to see this list on its own.~%~%")))

(defparameter *ps3-expected* (ps3-read-table "tests/expected.tsv"))
(defparameter *ps3-predictions* (ps3-read-table "predictions.tsv"))

(defun ps3-check-table-shape (path rows)
  (unless (equal (first rows) *ps3-columns*)
    (ps3-abort "~a has the wrong columns. The header must be exactly ~{~a~^<TAB>~}."
               path *ps3-columns*))
  (unless (equal (mapcar #'first (rest rows)) *ps3-ids*)
    (ps3-abort "~a must hold P01 through P16 in order." path))
  (dolist (row (rest rows))
    (unless (= (length row) (length *ps3-columns*))
      (ps3-abort "~a, row ~a: found ~d fields, expected ~d. Run ./lint."
                 path (first row) (length row) (length *ps3-columns*)))))

(ps3-check-table-shape "tests/expected.tsv" *ps3-expected*)
(ps3-check-table-shape "predictions.tsv" *ps3-predictions*)

(unless (equal *ps3-ids* (mapcar #'car *ps3-cases*))
  (ps3-abort "the expected table and the case corpus disagree on case ids."))

;;; Re-derive every published expectation before scoring anything against it.
;;; A stale tests/expected.tsv would otherwise grade a correct prediction as
;;; wrong, and the pair would never find out why.

(dolist (row (rest *ps3-expected*))
  (let ((case-id (first row))
        (published (rest row)))
    (let ((observed (ps3-describe-case case-id)))
      (loop for field in *ps3-fields*
            for got in observed
            for want in published
            do (unless (string= got want)
                 (ps3-abort "published expectation drifted for ~a.~a: expected ~a, CLISP produced ~a"
                            case-id field want got))))))

;;; Scoring.

(defparameter *ps3-passed* 0)
(defparameter *ps3-total* 0)

(defun ps3-check (label thunk)
  (incf *ps3-total*)
  (let ((ok (handler-case (funcall thunk)
              (error (condition)
                (format t "    ~a~%" condition)
                nil))))
    (if ok
        (progn (incf *ps3-passed*) (format t "PASS ~a~%" label))
        (format t "FAIL ~a~%" label))))

(defun ps3-need (name)
  "The student's function NAME, or an error naming what is missing. A renamed
or missing function fails its own checks and leaves every other group alone."
  (unless (fboundp name)
    (error "~(~a~) is not defined in src/evaluator.lisp" name))
  (symbol-function name))

(defun ps3-call (name &rest arguments)
  (apply (ps3-need name) arguments))

(defun ps3-signals-p (thunk)
  (handler-case (progn (funcall thunk) nil)
    (error () t)))

;;; Part 1 -- the prediction table.

(format t "== predictions ==~%")
(loop for expected-row in (rest *ps3-expected*)
      for prediction-row in (rest *ps3-predictions*)
      do (let ((case-id (first expected-row))
               (wanted (rest expected-row))
               (given (rest prediction-row)))
           (loop for field in *ps3-fields*
                 for want in wanted
                 for got in given
                 do (let ((label (format nil "~a.~a" case-id field))
                          (want-cell want)
                          (got-cell got))
                      (ps3-check label
                                 (lambda () (string= got-cell want-cell)))))))

;;; Part 2 -- the evaluator.

(format t "~%== implementation ==~%")

;; LOAD evaluates one form at a time, so a fault after the last complete DEFUN
;; still leaves every function defined and every check below passing. The file
;; is broken all the same, so the load gets a check of its own. Without it a
;; truncated file scores full marks and exits 0.
(defparameter *ps3-load-fault* nil)
(handler-case (ps3-load "src/evaluator.lisp")
  (error (condition)
    (setf *ps3-load-fault*
          (format nil "~a signalled ~a" (type-of condition) condition))))

(ps3-check "evaluator_loads"
           (lambda ()
             (when *ps3-load-fault*
               (error "src/evaluator.lisp did not load cleanly. ~a" *ps3-load-fault*))
             t))

(ps3-check "E1.eval_number"
           (lambda () (eql (ps3-call 'eval-expr 42 '()) 42)))
(ps3-check "E1.eval_symbol"
           (lambda () (eql (ps3-call 'eval-expr 'x '((x . 7))) 7)))
(ps3-check "E1.lookup_first_match"
           (lambda () (eql (ps3-call 'lookup 'x '((x . 1) (x . 9))) 1)))
(ps3-check "E1.lookup_deeper"
           (lambda () (eql (ps3-call 'lookup 'y '((x . 1) (y . 2))) 2)))
;; This one asks for the working case as well as the error. A stub that
;; signals on everything would otherwise pass it without looking anything up.
(ps3-check "E1.lookup_unbound"
           (lambda ()
             (let ((fn (ps3-need 'lookup)))
               (and (eql (funcall fn 'x '((x . 1))) 1)
                    (ps3-signals-p (lambda () (funcall fn 'z '())))))))

(ps3-check "E2.apply_op_arithmetic"
           (lambda ()
             (and (eql (ps3-call 'apply-op '+ '(2 3)) 5)
                  (eql (ps3-call 'apply-op '- '(2 3)) -1)
                  (eql (ps3-call 'apply-op '* '(2 3)) 6))))
(ps3-check "E2.apply_op_unknown"
           (lambda ()
             (let ((fn (ps3-need 'apply-op)))
               (and (eql (funcall fn '+ '(2 3)) 5)
                    (ps3-signals-p (lambda () (funcall fn '/ '(6 3))))))))
(ps3-check "E2.eval_operands"
           (lambda ()
             (equal (ps3-call 'eval-operands '(1 (+ 1 1) x) '((x . 3))) '(1 2 3))))
(ps3-check "E2.eval_sum"
           (lambda () (eql (ps3-call 'eval-expr '(+ 1 2) '()) 3)))
(ps3-check "E2.eval_nested"
           (lambda () (eql (ps3-call 'eval-expr '(* (+ 1 2) (- 10 4)) '()) 18)))
(ps3-check "E2.eval_uses_env"
           (lambda () (eql (ps3-call 'eval-expr '(+ x 1) '((x . 5))) 6)))

(ps3-check "E3.extend_env"
           (lambda ()
             (equal (ps3-call 'extend-env '(a b) '(1 2) '((c . 3)))
                    '((a . 1) (b . 2) (c . 3)))))
(ps3-check "E3.extend_env_leaves_input"
           (lambda ()
             (let ((env (list (cons 'c 3))))
               (ps3-call 'extend-env '(a) '(1) env)
               (equal env '((c . 3))))))
(ps3-check "E3.let_binds_body"
           (lambda () (eql (ps3-call 'eval-expr '(let ((x 2)) (* x x)) '()) 4)))
(ps3-check "E3.let_shadows_outer"
           (lambda () (eql (ps3-call 'eval-expr '(let ((x 2)) x) '((x . 9))) 2)))
(ps3-check "E3.let_ends_at_body"
           (lambda ()
             (eql (ps3-call 'eval-expr '(let ((x 1)) (+ (let ((x 2)) x) x)) '()) 3)))
(ps3-check "E3.let_binds_in_parallel"
           (lambda ()
             (eql (ps3-call 'eval-expr '(let ((x 1)) (let ((x 2) (y x)) (+ x y))) '()) 3)))

(ps3-check "E4.make_closure_shape"
           (lambda ()
             (equal (ps3-call 'make-closure '(n) '(+ n 1) '((c . 3)))
                    '(:closure (n) (+ n 1) ((c . 3))))))
(ps3-check "E4.apply_closure"
           (lambda ()
             (eql (ps3-call 'apply-closure
                            (ps3-call 'make-closure '(n) '(+ n 1) '((n . 100)))
                            '(5))
                  6)))
(ps3-check "E4.apply_closure_arity"
           (lambda ()
             (let ((fn (ps3-need 'apply-closure))
                   (closure (ps3-call 'make-closure '(n) '(+ n 1) '())))
               (ps3-signals-p (lambda () (funcall fn closure '(1 2)))))))
(ps3-check "E4.lambda_applied_directly"
           (lambda () (eql (ps3-call 'eval-expr '((lambda (n) (* n 2)) 21) '()) 42)))
(ps3-check "E4.lambda_through_variable"
           (lambda ()
             (eql (ps3-call 'eval-expr '(let ((f (lambda (n) (+ n 1)))) (f 41)) '()) 42)))
(ps3-check "E4.lambda_as_argument"
           (lambda ()
             (eql (ps3-call 'eval-expr
                            '(let ((apply-twice (lambda (g) (g (g 1)))))
                               (apply-twice (lambda (n) (+ n 10))))
                            '())
                  21)))
(ps3-check "E4.lexical_scope"
           (lambda ()
             (eql (ps3-call 'eval-expr
                            '(let ((x 2))
                               (let ((f (lambda (y) (+ x y))))
                                 (let ((x 100))
                                   (f 1))))
                            '())
                  3)))

;;; Part 3 -- the written comparison.

(defun ps3-read-file (path)
  (with-open-file (stream path :direction :input :if-does-not-exist nil)
    (when stream
      (with-output-to-string (out)
        (loop for line = (read-line stream nil nil)
              while line
              do (write-line line out))))))

(defun ps3-word-count (text)
  (let ((count 0)
        (in-word nil))
    (loop for character across text
          do (if (member character '(#\Space #\Tab #\Newline #\Return #\Page))
                 (setf in-word nil)
                 (unless in-word
                   (setf in-word t)
                   (incf count))))
    count))

(format t "~%== analysis ==~%")
(ps3-check "analysis_written"
           (lambda ()
             (let ((text (ps3-read-file "ANALYSIS.md")))
               (and text
                    (null (search "Replace this paragraph" text))
                    (let ((count (ps3-word-count text)))
                      (and (>= count 300) (<= count 450)))))))

(format t "~%== result ==~%")
(format t "~d/~d checks passed~%" *ps3-passed* *ps3-total*)
(unless (= *ps3-passed* *ps3-total*)
  (ext:exit 1))

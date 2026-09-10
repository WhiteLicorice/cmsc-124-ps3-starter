;;;; support.lisp -- the grader's notation, the course kind vocabulary, and
;;;; the head classification.
;;;;
;;;; The grader re-derives every published expectation through these functions
;;;; before it scores a single check, so a change here that disagrees with
;;;; tests/expected.tsv stops the run instead of grading against a stale table.

(defun ps3-notate-elements (value out)
  (let ((first-element t))
    (loop for rest = value then (cdr rest)
          while (consp rest)
          do (if first-element (setf first-element nil) (write-char #\, out))
             (write-string (ps3-notate (car rest)) out))))

(defun ps3-notate (value)
  "The grader's printed notation for VALUE. It never holds a space, so no cell
in predictions.tsv has to carry one."
  (cond
    ((null value) "nil")
    ((eq value t) "t")
    ((symbolp value) (string-downcase (symbol-name value)))
    ((integerp value) (format nil "~d" value))
    ((rationalp value) (format nil "~d/~d" (numerator value) (denominator value)))
    ((stringp value) (format nil "\"~a\"" value))
    ((characterp value) (format nil "#\\~a" value))
    ((functionp value) "#<function>")
    ((consp value)
     (with-output-to-string (out)
       (write-char #\( out)
       (ps3-notate-elements value out)
       (write-char #\) out)))
    (t "#<other>")))

(defparameter *ps3-kinds*
  '("null" "cons" "symbol" "integer" "ratio" "string" "character" "function"))

(defun ps3-kind (value)
  "The course kind of VALUE.

This is deliberately not TYPE-OF. ANSI leaves TYPE-OF's answers to the
implementation, so (type-of 3) may read FIXNUM on one build and INTEGER on
another, and the published table would then be wrong on one of them. The
vocabulary here is fixed by the course and separates null from cons from
symbol, which is the distinction NIL keeps blurring."
  (cond
    ((null value) "null")
    ((consp value) "cons")
    ((symbolp value) "symbol")
    ((integerp value) "integer")
    ((rationalp value) "ratio")
    ((stringp value) "string")
    ((characterp value) "character")
    ((functionp value) "function")
    (t "other")))

(defun ps3-length (value)
  "How many top-level elements VALUE holds, or none when it is not a sequence.
NIL is the empty list as well as a symbol, so its length is 0 and not none."
  (if (or (null value) (consp value) (stringp value))
      (format nil "~d" (length value))
      "none"))

(defparameter *ps3-operators*
  '("function" "special-operator" "macro" "none"))

(defun ps3-operator (form)
  "How the head of FORM is classified, or none when FORM is an atom.

The order of the tests is a course rule, not a fact about the language. ANSI
lets an implementation supply a special operator and a macro for the same name,
and CLISP does that for AND, OR, WHEN, UNLESS, COND, and CASE. All six answer
yes to both SPECIAL-OPERATOR-P and MACRO-FUNCTION. Asking SPECIAL-OPERATOR-P
first is what settles them."
  (if (and (consp form) (symbolp (car form)))
      (let ((head (car form)))
        (cond
          ((special-operator-p head) "special-operator")
          ((macro-function head) "macro")
          ((fboundp head) "function")
          (t "unknown")))
      "none"))

(defparameter *ps3-fields* '("value" "kind" "length" "operator"))

(defun ps3-case-form (case-id)
  (let ((entry (assoc case-id *ps3-cases* :test #'string=)))
    (unless entry
      (error "unknown case: ~a" case-id))
    (cdr entry)))

(defun ps3-describe-case (case-id)
  "The four published fields for CASE-ID, derived by evaluating the form."
  (let* ((form (ps3-case-form case-id))
         (value (eval form)))
    (list (ps3-notate value)
          (ps3-kind value)
          (ps3-length value)
          (ps3-operator form))))

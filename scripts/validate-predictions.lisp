;;;; validate-predictions.lisp -- form checks for predictions.tsv.
;;;;
;;;; This file never reads tests/expected.tsv and never evaluates a case, so
;;;; running it tells you nothing about whether an answer is right. That is
;;;; what makes it safe to run before the prediction commit.
;;;;
;;;; It reads raw lines rather than parsed fields, because the parse hides the
;;;; faults it looks for. A padded cell survives the parse and then fails its
;;;; comparison, which reads like a wrong prediction rather than a stray space.
;;;; One trailing space per line fails all 16 operator checks that way.

(defparameter *ps3-columns* '("id" "value" "kind" "length" "operator"))

(defparameter *ps3-ids*
  (loop for n from 1 to 16 collect (format nil "P~2,'0d" n)))

(defun ps3-split-tab (line)
  (let ((fields '())
        (start 0))
    (loop for pos = (position #\Tab line :start start)
          do (push (subseq line start pos) fields)
             (if pos (setf start (1+ pos)) (return)))
    (nreverse fields)))

(defun ps3-read-lines (path)
  "Every line of PATH, or :missing when the file is not there. A trailing
carriage return is stripped, because a CRLF file grades correctly and is not a
fault. So is a blank line at the end."
  (with-open-file (stream path :direction :input :if-does-not-exist nil)
    (if (null stream)
        :missing
        (let ((lines (loop for line = (read-line stream nil nil)
                           while line
                           collect (string-right-trim '(#\Return) line))))
          (loop while (and lines (string= (car (last lines)) ""))
                do (setf lines (butlast lines)))
          lines))))

(defun ps3-blank-p (text)
  (string= (string-trim '(#\Space #\Tab) text) ""))

(defun ps3-padded-p (text)
  (not (string= text (string-trim '(#\Space #\Tab) text))))

(defun ps3-whole-number-p (text)
  (and (plusp (length text))
       (every (lambda (character) (digit-char-p character)) text)))

(defun ps3-validate-predictions (path)
  "Two lists. The first holds malformations, the second holds cells still
reading TODO."
  (let ((problems '())
        (todos '())
        (lines (ps3-read-lines path)))
    (labels ((note (&rest pieces)
               (push (apply #'concatenate 'string pieces) problems)))
      (cond
        ((eq lines :missing)
         (note path " is missing."))
        ((null lines)
         (note path " is empty."))
        (t
         (unless (equal (ps3-split-tab (first lines)) *ps3-columns*)
           (note "line 1: the header row must be exactly "
                 (format nil "~{~a~^<TAB>~}" *ps3-columns*) "."))
         (let ((wanted (1+ (length *ps3-ids*))))
           (unless (= (length lines) wanted)
             (note (format nil "the file holds ~d lines. It needs ~d, one header ~
and one row for each of P01 to P16." (length lines) wanted))))
         (loop for line in (rest lines)
               for index from 2
               for row from 1
               do (let ((fields (ps3-split-tab line))
                        (label (format nil "line ~d" index)))
                    (if (/= (length fields) (length *ps3-columns*))
                        (note (format nil "~a: found ~d fields, expected ~d. ~
Separate the columns with one tab each and use no tab anywhere else. An editor ~
set to insert spaces instead of tabs lands here."
                                      label (length fields) (length *ps3-columns*)))
                        (progn
                          (loop for cell in fields
                                for column in *ps3-columns*
                                do (let ((where (format nil "~a, column ~a" label column)))
                                     (cond
                                       ((string= cell "")
                                        (note where ": the cell is empty."))
                                       ((ps3-blank-p cell)
                                        (note where ": the cell holds only whitespace."))
                                       (t
                                        (when (ps3-padded-p cell)
                                          (note where ": the cell has leading or trailing "
                                                "whitespace. The comparison is exact, so \""
                                                cell "\" is not the same answer as \""
                                                (string-trim '(#\Space #\Tab) cell) "\"."))
                                        (when (find #\Space (string-trim '(#\Space #\Tab) cell))
                                          (note where ": the cell holds a space. No field in "
                                                "this table has one, so \"(1, 2)\" fails "
                                                "where \"(1,2)\" passes."))))))
                          (let ((found-id (string-trim '(#\Space #\Tab) (first fields)))
                                (wanted-id (nth (1- row) *ps3-ids*)))
                            (when (and wanted-id (not (string= found-id wanted-id)))
                              (note (format nil "~a: the id reads \"~a\". Row ~d must be ~a, ~
and all 16 ids stay in order." label found-id row wanted-id))))
                          (let ((cells (mapcar (lambda (cell)
                                                 (string-trim '(#\Space #\Tab) cell))
                                               (rest fields))))
                            (if (member "TODO" cells :test #'string=)
                                (push (format nil "~a: ~d of 4 cells still read TODO"
                                              (string-trim '(#\Space #\Tab) (first fields))
                                              (count "TODO" cells :test #'string=))
                                      todos)
                                (destructuring-bind (value kind length operator) cells
                                  (declare (ignore value))
                                  (unless (member kind *ps3-kinds* :test #'string=)
                                    (note (format nil "~a, column kind: \"~a\" is not one of ~
the course kinds. They are ~{~a~^, ~}." label kind *ps3-kinds*)))
                                  (unless (or (string= length "none")
                                              (ps3-whole-number-p length))
                                    (note (format nil "~a, column length: \"~a\" is neither ~
none nor a whole number. A sequence has 0 or more elements and everything else ~
answers none." label length)))
                                  (unless (member operator *ps3-operators* :test #'string=)
                                    (note (format nil "~a, column operator: \"~a\" is not one ~
of ~{~a~^, ~}." label operator *ps3-operators*)))))))))))))
    (list (nreverse problems) (nreverse todos))))

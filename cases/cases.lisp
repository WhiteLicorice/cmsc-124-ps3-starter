;;;; cases.lisp -- the sixteen forms of the prediction table, stored
;;;; unevaluated.
;;;;
;;;; Every case stands on its own. None of them depends on another having run
;;;; first, so ./run works on any id in any order.

(defparameter *ps3-cases*
  (list
    (cons "P01" '(+ 1 (* 2 3)))
    (cons "P02" ''(+ 1 2))
    (cons "P03" 'nil)
    (cons "P04" 't)
    (cons "P05" '(symbolp nil))
    (cons "P06" '(car '()))
    (cons "P07" '(cons 1 '(2 3)))
    (cons "P08" '(if (null '()) 'empty 'full))
    (cons "P09" '(and 1 nil 3))
    (cons "P10" '(progn
                   (defvar *ps3-rate* 2)
                   (defun ps3-scale (n) (* n *ps3-rate*))
                   (let ((*ps3-rate* 10)) (ps3-scale 3))))
    (cons "P11" '(defun ps3-twice (n) (* n 2)))
    (cons "P12" '(labels ((down (n) (if (= n 0) '() (cons n (down (- n 1))))))
                   (down 3)))
    (cons "P13" '(mapcar #'length '((1 2) () (3))))
    (cons "P14" '(mapcar (lambda (n) (* n n)) '(1 2 3)))
    (cons "P15" '(lambda (n) (* n 2)))
    (cons "P16" '(let ((factor 2))
                   (let ((f (lambda (n) (* n factor))))
                     (let ((factor 10))
                       (funcall f 3)))))))

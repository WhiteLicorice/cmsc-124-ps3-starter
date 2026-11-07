# Reasoning for the Predictions Table

Write one entry under every heading below, then commit this file together with
`predictions.tsv`, before you run a case or open `tests/expected.tsv`.

Each entry names the rule that produces the four predicted fields for that
case. One to three sentences is enough. The grader checks structure only. It
does not judge quality, and it sets no word minimum.

After you run the cases, add a short correction under each case you predicted
wrongly. Say what you predicted, what CLISP printed, and which rule you
misread. Those entries belong in the correction commits.

## P01
`'(+ 1 (* 2 3))` heads with the `+` function. The integer `1` and list `(* 2 3)` is handed to `+` for evaluation and returns `7`. That is an integer, so the length is `none` and the head is a `function`.

## P02
`(+ 1 2)` heads with the `+` function. The integers `1` and `2` are handed to `+` for evaluation and returns `3`. That is the integer so the length is `none` and the head is a `function`.

## P03
`nil` is an atom so both it's value and kind are itself. Since `nil` is an atom, length is `none` and there are no operators.

## P04
`t` is a symbol so the value is itself and the kind is symbol. Because `t` is a symbol the both length and operator is `none`.

## P05
`(symbolp, nil)` heads with the symbol `symbolp`. It is a list unevaluated (because of `quote`) so the kind is a list, while the length is 2 and the operator is `none`.

## P06
`(car '())` heads with the `car` function. `car` is handed an empty list so the kind is `nil` and length is `none`. Since `car` heads, the operator is a `function`.

## P07
`(cons 1 '(2 3))` heads with `cons` function. The integer `1` is added to `(2 3)` list (by `cons`) so the list is now (1 2 3) therefore the kind is a `list`, the length 3, and operator is `function`.

## P08
`(if (null '()) 'empty 'full)` heads with the special operator `if`. The arguments of an if function in LISP follows: `<if condition then else>` and the condition asks if null is an empty list (which it is) and the corresponding branch is the if argument that returns `empty`. Therefore the kind is `symbol`, length is `none`, and operator is `special operator`.

## P09
`(and 1 nil 3)` is headed by the `and` special operator which goes over its arguments and returns `nil` if it's among the list but returns the final value if none found. Since there is a `nil` in the given list, the kind is `nil`, the length is `none`, and the operator is `special operator`.

## P10
`progn (defvar...) (defun...) (let...)` is headed by the `progn` special operator that runs all the fuctions wrrapped by it but returns the value of the last function only which is the function headed by `let`. Source: `https://www.lispworks.com/documentation/HyperSpec/Body/s_progn.htm`

## P11
`defun ps3-twice (n) (* n 2)` is headed by the `defun` macro that defines a function globally and returns the `symbol` that defines the function which is `ps3-twice`. So kind is `symbol`, length is `none`, and operator is `macro`.

## P12
`(labels ((down (n)... )` is headed by the `labels` special function that defines a function locally within scope and is recursive and returns the value of the last evaluated expression in the body which is `2`. So kind is `integer`, length is `none`, and operator is `special operator`. Source: `https://www.lispworks.com/documentation/HyperSpec/Body/s_flet_.htm`

## P13
`(mapcar #'length...)` is headed by the `mapcar` function which maps the `length` function to `(1 2)`, `()`, and `(3)` and returns a list of values which is `(2 0 1)`. Kind is `list`, length is `3`, and operator is `function`.

## P14
`(mapcar (lambda (n)...))` maps the `lambda` function to one list only which is `(1 2 3)` and returns `(1 4 9)`. The kind is `list`, length is `3`, and opertaor is `function`.

## P15
`(lambda (n) (* n 2))` is headed by `lambda` function that initializes a no-name function. But since there's no input, the kind is `none`, length is `none`, and the operator is still `function`.

## P16
`(let ((factor 2))...` is headed by `let` that locally declares a variable `factor` equal to 2 and the second `let` declares `f` as a lambda and a third `let` declares another `factor` variable equal to 10 and `funcall f 3` evaluates to `3 * 10` equals to `30`. So the kind is `integer`, the length is `none`, and operator is `function`.
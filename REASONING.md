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
`(if (null '()) 'empty 'full)` heads with the special operator `if`.

## P09
Replace this line with the rule behind this case's four fields.

## P10
Replace this line with the rule behind this case's four fields.

## P11
Replace this line with the rule behind this case's four fields.

## P12
Replace this line with the rule behind this case's four fields.

## P13
Replace this line with the rule behind this case's four fields.

## P14
Replace this line with the rule behind this case's four fields.

## P15
Replace this line with the rule behind this case's four fields.

## P16
Replace this line with the rule behind this case's four fields.

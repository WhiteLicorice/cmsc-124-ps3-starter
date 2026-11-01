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
value: 7 (a compound form follows the rule selected by its head), kind: integer (the variables the + function performed upon are integers), length: 3 (there is a function, an integer, and a list inside the main list), operator: function (+ is classified as a function)

## P02
value: 3 (a compound form follows the rule selected by its head), kind: integer (the variables the + function performed upon are integers), length: 3 (there is a function, and two integers inside the list), operator: function (+ is classified as a function)

## P03
value: null, kind: nil, length: 0 (nil is an empty list), operator: none

## P04
value: null, kind: symbol (t is considered as a symbol), length: 1, operator: none

## P05
Replace this line with the rule behind this case's four fields.

## P06
Replace this line with the rule behind this case's four fields.

## P07
Replace this line with the rule behind this case's four fields.

## P08
Replace this line with the rule behind this case's four fields.

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

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
The multiplication evaluated  2 * 3, which is 6 + 1 = 7 due to the addition outside, which is an integer. Length is none, and the + is a function.

## P02
quote returns (+ 1 2) unevaluated. This is a list so kind is cons. which means it has a valid length 3, and quote is a special-operator.

## P03
nil is classified as null, since it is empty the length is 0.
it is atomic so operator is none.

## P04
t is a symbol even if it represents true. Not a sequence of elements so its length is none. It is atomic so operator is none.

## P05
symbolp evaluates nil and returns t since it is a symbol. This means length is none, and operator is a function which is symbolp.

## P06
quote passes unevaluated list to car. car returns first element and the list is empty, so result is nil. Kind is null, which is length 0. car is a function here.

## P07
cons adds the element 1 to the existing list before 2 and 3. Hence, kind is cons, its length is now 3, and the operator cons is a function.

## P08
null evaluates '() as an empty list and returns t. if then picks the true-clause. So the value is empty, this is a symbol, so length is none. and if is a special operator.

## P09
and evaluates until it encounters a false value. nil is false so value is nil, kind is null, which makes length 0, and the operator and is a special-operator

## P10
Dynamic scoping lets let's declaration of *ps3-rate* to 10 which is passed once we call the function locally, this is because defvar turns it into a special variable, which means any let block will create a temporary dynamic binding instead of a local lexical binding. the value is then 30, with kind integer, length none, and operator being a special operator.

## P11
No calling has occured yet. Evaluating defun returns its function name which is ps3-twice. That is a symbol. So length is none, and defun is a macro.

## P12
labels defines a recursive function called down and it stops when n reaches 0, returning an empty list. we can see in each iteration, cons n adds onto the list, until it eventually produces (3 2 1). So value is (3,2,1) the kind is then cons, length is 3, and the operator is a special operator.

## P13
mapcar applies a function to every element of a list and returns the results. We evaluate 3 inner lists with length
which returns (2 0 1). Value is (2,0,1), kind is cons, length is 3, and operator here is a function.

## P14
mapcar applies the anonymous function lambda to each element in the list, so each element is multiplied by itself. returning (1 4 9). Value is (1,4,9), kind is cons, length is 3, and operator is a function.

## P15
We are not calling anything, but lambda creates the raw object itself so its value is #<function>. Kind is function, length being none, and operator is a macro.

## P16
factor is not a special variable, so lexical scoping is done.
So we bind 2 for factor, as the inner let binding of 10 does not change what the function uses. The value is then 6, with kind integer, length none, and operator as special-operator.

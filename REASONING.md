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
+ is a function, so it evaluates all its arguments, left to right. The inner form `(* 2 3)` gives 6 first, so + receives 1 and 6 in that order. 

## P02
The head is quote (the reader turns ' into (quote ...)), which is a special-operator because it does not evaluate its arguments. So (+ 1 2) is never evaluated. It comes back as a list whose first element is the symbol +, and the value is (+,1,2) with 3 elements, a kind is cons. 

## P03
`nil` is an empty list. The kind is null because null is the kind whose only member is nil, so the empty list gets its own kind rather than any other kind like symbol or cons. Length is 0 because lists are sequences, and `none` is only for non-sequences. The operator is none because there is no head operator. 

## P04
`t` is a symbol. The length is none because it is not a sequence. The operator is none because there is no head operator. The leading ' is how the corpus stores the case. 

## P05
The operator is function because symbolp is considered a function. The argument nil (which is also a symbol) evaluates to itself, then symbolp returns t. Kind is symbol because `t` is a symbol. Length is none because t is a non-sequence

## P06
`car` is a function, so it evaluates `'()`
to an empty list; car of that is `nil`. Since the value is nil, the kind is null and the length is 0

## P07
`cons` is a function. Evaluating both arguments 1 and '(2 3) which is `quote (2 3)` which returns as plain data, cons takes 1 into the front of the list in the second argument and thus makes the value (1,2,3) of kind cons because its a non-empty list built from the cons element in the result's first cell, and length 3 which comes from the length of (2 3) plus the 1 argument.

## P08
The head if is a special-operator because it does not evaluate all its arguments up front. `'()` evaluates to the empty list, which is nil, null receives that and then returns t, so `if` sees that and so picks empty and skips full; the result is the symbol empty, so the kind is symbol and the length is none

## P09
The operator is special-operator as it does not evaluate its arguments up front. The value is nil because the and operator checks through each of its arguments from left to right until it finds a false value, in this case it's nil. Therefore the kind is null and the length is 0.

## P10
`progn` is a special-operator because it returns the last; `defvar` makes `*ps3-rate*` special, so `ps3-scale` sees 10 when called inside teh let; the result is 30 (from the operation `(* n *ps3-rate*)`), so the kind is integer and the length is none. 

## P11
`defun` is a macro because it rewrites the form into other code; it installs the function and returns the name of the funciton, so the kind is symbol, and the length is none; 


## P12
The head `labels` is a special-operator because it does not evaluate its arguments up front. `if`, `cons`, and `quote` are not the head of this case. It `down` counts down from 3 and by 1 until  n is 0, and then each call uses cons to attach its n to the front of the list that the recursive call returns, and so the value is (3,2,1). Since it is a non-empty list built from cons cells, the kind is cons and the length is 3.

## P13
`mapcar` is a function because it evaluates its arguments before it runs. It applies the specified function where it returns the length of a given list, and then applies it to each list in the argument, returns the results into a new list in order, and thus the value becomes a non-empty list. Therefore the kind is cons and the length is 3. 

## P14
`mapcar` is a function because it evaluates its arguments before it runs; the lambda evaluates to a function object, which `mapcar` calls on each element of (1 2 3) with n bound to each element; the lambda function calls (* n n) on each element so the result is (1,4,9). The kind is therefore cons and the length is 3 because it is a non-empty list with a result per input element. 

## P15
The leading `lambda` is a macro because the macro expands the code into `(function (lambda (n) (* n 2)))`, which is a function object. It is not a function because it does not evaluate its arguments as ordinary arguments. `(* n 2)` does not run because nothing calls the function here, and so the value is the function object itself `#<function>`. Therefore the kind is function, and the length is none. 

## P16
The outermost head `let` is a special-operator because it does not evaluate its bindings as ordinary arguments. `f` lexically captures factor as 2 where the lambda was created, and because factor is an ordinary variable, the inner rebinding to 10 is ignored because the inner `let` makes a new, separate factor that f can't see. So `(funcall f 3)` gives 6, an integer, therefore the kind is integer and the length is none because it is not a list, vector, or string.

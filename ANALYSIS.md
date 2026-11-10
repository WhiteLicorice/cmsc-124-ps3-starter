# Environments and the Toy Evaluator

The `env` parameter holds the defining environment of the evaluation which is a list of name value pairs. The definition of `extend-env` reveals what an environment contains when it is captured, the names and their inits, which in our application of lisp is defined within the `let` expression and covered in `eval-let` which defines a new environment in the first, extends the captured one, then executes second argument the body with this new environment.
```
(append (mapcar #'cons params args) env)
```
Is the line that ensures the captured environment is not overwritten during extension.
`(mapcar #'identity (list :closure params body env))` is where the environment is captured during closures
When a lambda is defined inside a nested `let` expression, the `let` parents get evaluated and put into the new environment that is extended into the `lambda` evaluation's environment.

If `apply-closure` extended the environment of the caller, instead of the one captured in the closure then it would follow dynamic scoping. In this case `make-closure` would omit the environment it was defined in instead of saving it in the closure and `apply-closure` would have the `env` parameter instead and capture the environment of the function caller when it is called.

```
(eval-expr '(let ((x 2))
              (let ((f (lambda (y) (+ x y))))
                (let ((x 100))
                  (f 1))))
           '())
```

The function call here would utilize the `let ((x 100))` from the environment of `(f 1)` instead of the definition environment's `let ((x 2))` and the result would be `101` instead of `3`

CLISP needs `funcall` because it stores functions and variables in separate namespaces.
When you try to use the function object in a function call syntax, the language looks for a function definition then doesn't find anything defined and throws the error. The toy language we have created binds functions to the same environment we use for variables by utilizing closures stored in the environment which are a set of values that contains the functions body and captured environment.

When the function `f` is evaluated the program looks through the environment for `f` and finds a `closure`. That closure undergoes evaluation with
```
(t (apply-closure(eval-expr(car expr) env) (eval-operands (cdr expr) env)))
```
Where it is evaluated using `apply-closure`

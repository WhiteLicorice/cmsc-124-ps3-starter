# Environments and the Toy Evaluator

The expression `(let ((factor 2)) (let ((f (lambda (n) (* n factor)))) (let ((factor 10)) (f 3))))` demonstrates how lexical scoping works in the toy evaluator.

First, `eval-expr` at line 127 encounters the outer `let` and passes it to `eval-let` (line 67). The initial value `2` is evaluated in an empty environment, then `extend-env` (line 65) adds `(factor . 2)` to the environment. The body is then evaluated using this updated environment.

Next, the second `let` creates the lambda assigned to `f`. The evaluator recognizes the lambda expression at line 131 and calls `make-closure` at line 132, passing the current environment. At line 90, the closure stores the parameter, body, and environment where it was defined: `(:closure (n) (* n factor) ((factor . 2)))`. This is important because a closure remembers the environment where the lambda was created, rather than the environment where it is eventually called.

The third `let` introduces another `factor`, this time with a value of `10`. This creates a new environment: `((factor . 10) (f . closure) (factor . 2))`. When `(f 3)` is evaluated, the application branch at lines 136–138 looks up `f` in the current environment and evaluates the argument, resulting in `(3)`.

When `apply-closure` (line 104) executes, it extends the environment stored inside the closure instead of using the current caller environment. This produces `((n . 3) (factor . 2))`. As a result, evaluating `(* n factor)` finds `n = 3` and `factor = 2`, giving us **6**.

If the evaluator instead used the caller's environment when applying the closure, it would find the innermost `factor`, which has a value of `10`. The expression would then return `30` instead. This would be dynamic scoping rather than lexical scoping, causing the E4 lexical-scope tests, which expect `3`, `101`, and `102`, to fail.

Lastly, the host code needs `funcall` because CLISP follows a Lisp-2 model, meaning variables and functions have separate namespaces. Since the closure is stored as the value of the variable `f`, writing `(f 3)` would make CLISP look for a function named `f` instead. Using `(funcall f 3)` tells it to invoke the function stored in the variable.

The toy evaluator, on the other hand, follows a Lisp-1 model. At line 137, it evaluates the operator expression using the same `lookup` function used for regular variables. This means `f` directly evaluates to the closure, so there is no need for `funcall` or `#'`.
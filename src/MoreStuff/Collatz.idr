module MoreStuff.Collatz

export
collatz_iterate: Int -> Int
collatz_iterate n = if (mod n 2 == 0) then (div n 2) else (3 * n + 1)

export
collatz_iterations: Int -> Int -> Int
collatz_iterations n acc = if (n == 1) then acc else (collatz_iterations (collatz_iterate n) (acc+1))

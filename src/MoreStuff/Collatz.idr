module MoreStuff.Collatz

export
collatz_iterate: Int -> Int
collatz_iterate n = if (mod n 2 == 0) then (div n 2) else (3 * n + 1)

export
collatz_iterations: { default 0 acc: Int }  -> Int -> Int
collatz_iterations { acc } n = if (n == 1) then acc else
    (collatz_iterations { acc = acc + 1 } (collatz_iterate n))

module MoreStuff.GraphAlgo

import Data.Fin
import Data.Vect

||| Iterate a function on an argument until the result stabilizes
export
iterateToFixed: Eq a => (a -> a) -> a -> a
iterateToFixed fun arg =
    let farg = fun arg in
    if (farg == arg) then farg else iterateToFixed fun farg

||| Build an equivalence relation from a list of pairs of integers in the range 0 to n.
||| Result is expressed as a list of indices representing equivalence classes.
export
buildEquiv: (len: Nat) -> List (Fin len, Fin len) -> Vect len (Fin len)
buildEquiv len relators = let
    base: Vect len (Fin len) = range in
--        range
    foldr f base relators where
        f (x, y) classes = let
--            trackUp = \i: Int => i
            xx = trackUp x
            yy = trackUp y in
            classes where
                trackUp: Fin len -> Fin len
                trackUp = iterateToFixed $ \j => index j classes
{-
            classes where
                trackUp: Int -> Int
                trackUp j = index (the Nat j) range
--                trackUp j = index (cast j) range
                -- (\n: Int => index (cast n) range) j
                -- iterateToFixed

-}
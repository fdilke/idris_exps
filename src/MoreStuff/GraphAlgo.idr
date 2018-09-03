module MoreStuff.GraphAlgo

import Data.Fin
import Data.Vect

||| Iterate a function on an argument until the result stabilizes
export
iterateToFixed: Eq a => (a -> a) -> a -> a
iterateToFixed fun arg =
    let farg = fun arg in
    if (farg == arg) then farg else
        iterateToFixed fun farg

trackUp: Vect len (Fin len) -> Fin len -> Fin len
trackUp classes =
    iterateToFixed (`index` classes)

sweep: Vect len (Fin len) -> Vect len (Fin len)
sweep classes =
    (trackUp classes) <$> classes

||| Build an equivalence relation from a list of pairs of integers in the range 0 to n.
||| Result is expressed as a list of indices representing equivalence classes.
export
buildEquiv: (len: Nat) -> List (Fin len, Fin len) -> Vect len (Fin len)
buildEquiv len relators =
    sweep $ foldr merge range relators where
        merge (x, y) classes = let
            xx = trackUp classes x
            yy = trackUp classes y in
            if (xx == yy) then
                classes
            else
                replaceAt xx yy classes

||| Tell if a graph (expressed as list of edges) is a forest, i.e. has no cycles
export
isForest: List (a, a) -> Bool
isForest [] = True
isForest ((x, y) :: rest) = True

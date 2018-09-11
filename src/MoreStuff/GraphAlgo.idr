module MoreStuff.GraphAlgo

import Data.Fin
import Data.Vect
import Data.SortedMap

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

||| Tell if a graph (expressed as list of edges) has a cycle
export
hasCycle: Eq a => List (a, a) -> Bool
hasCycle [] = False
hasCycle ((x, y) :: edges) =
    if (x == y) then
        True
    else
        hasCycle (map bond2 edges) where
            bond: a -> a
            bond p = if (p == x) then y else p
            bond2: (a, a) -> (a, a)
            bond2 (p, q) = (bond p, bond q)

-- ||| Join two nodes in the context of a disjoint set, expressed as a (SortedMap a a)
-- ||| Return an additional flag saying if the nodes were already joined
parameters (dset: SortedMap a a)
    export
    join: a -> a -> (Bool, SortedMap a a)
    join x y = case (lookup x dset, lookup y dset) of
        (Just xx, Just yy) => (True, dset)
        _ => (False, dset)



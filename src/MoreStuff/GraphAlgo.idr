module MoreStuff.GraphAlgo

||| Iterate a function on an argument until the result stabilizes
export
iterateToFixed: Eq a => a -> (a -> a) -> a
iterateToFixed arg fun =
    let farg = fun arg in
    if (farg == arg) then farg else iterateToFixed farg fun

||| Build an equivalence relation from a list of pairs of integers in the range 0 to n.
||| Result is expressed as a list of indices representing equivalence classes.
export
buildEquiv: Int -> List (Int, Int) -> List Int
buildEquiv size relators = let
    range = [0,1..(size-1)] in
        range
module MoreStuff.GraphAlgo


||| Build an equivalence relation from a list of pairs of integers in the range 0 to n.
||| Result is expressed as a list of indices representing equivalence classes.
export
buildEquiv: Int -> List (Int, Int) -> List Int
buildEquiv size relators =
    [0,1..(size-1)]
module MoreStuff.Maze

import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Effect.Monad
import Control.IOExcept
import Data.Vect
import Data.String

import MoreStuff.GodelPerm
import MoreStuff.GraphAlgo

qSquare: String
qSquare = " ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█"

squareChar: Bool -> Bool -> Bool -> Bool -> String
squareChar nw ne sw se =
    let on: (Bool -> Int -> Int) =
            \flag, value => if flag then value else 0
        index = (on nw 1) + (on ne 2) + (on sw 4) + (on se 8)
        chars: (List Char) = [ strIndex qSquare index ]
        text: String = pack chars in
        text

rndFact : Nat -> Eff Integer [RND]
rndFact Z = pure 0
rndFact (S n) = do
    prevFact <- (rndFact n)
    let n1 = toIntegerNat $ S n
    shift <- rndInt 0 n1
--    putStrLn $ "shift: " ++ (show shift) ++ " from: " ++ (show n1)
    pure $ n1 * prevFact + shift

rndPerm : Vect n a -> Eff (Vect n a) [RND]
rndPerm {n=n} vs = do
--    putStrLn $ "VVV factorial of: " ++ (show n) ++ " : " ++ (show fact)
--    let fact = factorial n
--    code <- rndInt 0 fact
    code <- rndFact n
--    putStrLn $ "VVV code:  " ++ (show code)
    let perm = godelPerm n code
    let shuffled = map (\i => index i vs) perm
    pure shuffled

shuffle : List a -> Eff (List a) [RND]
shuffle xs = do
    vs <- rndPerm (fromList xs)
    pure $ toList vs

joinStrings: List String -> String
joinStrings = pack . concat . (map unpack)

showGrid:
    (List Int) ->
    (Int -> Int -> String) ->
    Eff () [STDIO]
showGrid nodes cellfn =
    putStr $ unlines $ map (\j =>
        joinStrings $ map (\i => cellfn i j) nodes
    ) nodes

mazeEdges : List (Int, Int) ->
    Eff (List ((Int, Int), (Int, Int))) [RND, STDIO, SYSTEM]
mazeEdges nodePairs = do
--    srand !time
    let graph: List ((Int, Int), (Int, Int)) = nub $ do
        (i, ip) <- nodePairs
        (j, jp) <- nodePairs
        k <- [((i, j), (ip, j)), ((i, j), (i, jp)), ((ip, j), (ip, jp)), ((i, jp), (ip, jp))]
        pure k
--    putStrLn "nubbed graph pre-shuffle:"
--    putStrLn $ show graph
--    putStrLn "nubbed graph pre-shuffle: (end)"
    rgraph <- shuffle graph
    pure $ spanningForest rgraph

effectMaze : Eff () [RND, STDIO, SYSTEM]
effectMaze = do
    args <- getArgs
    let defaultOrder : Int = 3
    let optionalOrder = index' 1 args >>= (parseInteger { a=Int })
    let order = fromMaybe defaultOrder optionalOrder
    let nodes: List Int = [0..(order-2)]
    let nodePairs: List (Int, Int) = map ( \i => (i, i + 1)) nodes
    let nodesPlus: List Int = [0..(order-1)]
    edges <- mazeEdges nodePairs
    shuffled <- shuffle [1..100]
--    putStrLn $ ("shuffled: " ++ (show shuffled))
--    putStrLn $ "Edges: " ++ ( show edges )
    let cellPair: (Int -> Int -> String) = \i, j =>
        "<" ++ (show i) ++ "," ++ (show j) ++ ">"
--    putStrLn "Grid: (cell squares)"
--    showGrid nodesPlus cellPair
    let hFlag = \i : Int, j : Int =>
        elem ((i - 1, j), (i, j)) edges
    let vFlag = \i : Int, j : Int =>
        elem ((i, j - 1), (i, j)) edges
    let cellFlags: (Int -> Int -> String) = \i, j =>
        " " ++
        (if (hFlag i j) then "T" else "F") ++
        (if (vFlag i j) then "T" else "F")
--    putStrLn "Grid: (not)"
--    showGrid nodesPlus cellFlags
    let cellQSquare: (Int -> Int -> String) = \i, j =>
        let hEnd = (i == order - 1)
            vEnd = (j == order - 1) in
            if (hEnd && vEnd) then
                squareChar True False False False
            else if hEnd then
                squareChar True False True False
            else if vEnd then
                squareChar True True False False
            else
                squareChar
                    True
                    (not (vFlag i j))
                    (not (hFlag i j))
                    False
--    putStrLn "QSquare:"
    showGrid nodesPlus cellQSquare
    pure ()

export
doMaze : IO ()
doMaze = do run effectMaze

--- experiments with monadic effects:
--    let k: List (Eff () [STDIO]) = map putStrLn ["Ho", "ho"]
--    let kk: (Eff (List ()) [STDIO]) = sequence k

experiment : MonadEff [RND, STDIO, SYSTEM] ()
experiment = monadEffT effectMaze

exp2 : String -> MonadEff [STDIO] ()
exp2 s = monadEffT $ do
    putStrLn s

exp3 : List String -> MonadEff [STDIO] ()
exp3 s = do
    sequence $ map exp2 s
    pure ()

--    MonadEff [STDIO] ()
-- is MonadEffT xs id ()
-- which is MkMonadEffT effect
-- where effect is an EffM m a xs (\v => xs)

-- exp4 : EffM _ () [STDIO] (\v => [STDIO])
-- exp4 = case (exp3 ["Hello", "there"]) of
--    MkMonadEffT effect => effect

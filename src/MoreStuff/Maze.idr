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
    pure $ n1 * prevFact + shift

rndPerm : Vect n a -> Eff (Vect n a) [RND]
rndPerm {n=n} vs = do
    code <- rndFact n
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
    (List Int) ->
    (Int -> Int -> String) ->
    Eff () [STDIO]
showGrid horzNodes vertNodes cellfn =
    putStr $ unlines $ map (\j =>
        joinStrings $ map (\i => cellfn i j) horzNodes
    ) vertNodes

mazeEdges : List (Int, Int) -> List (Int, Int) ->
    Eff (List ((Int, Int), (Int, Int))) [RND, SYSTEM, STDIO]
mazeEdges horzPairs vertPairs = do
    srand !time
    let graph: List ((Int, Int), (Int, Int)) = nub $ do
        (i, ip) <- horzPairs
        (j, jp) <- vertPairs
        k <- [((i, j), (ip, j)), ((i, j), (i, jp)), ((ip, j), (ip, jp)), ((i, jp), (ip, jp))]
        pure k
--    putStrLn "Shuffling graph..."
    rgraph <- shuffle graph
--    putStrLn "Calc spanning forest..."
    let forest = spanningForest rgraph
--    putStrLn "Calc spanning forest... done"
    pure forest

getArg : Nat -> Int -> Eff Int [SYSTEM]
getArg argNum defaultValue = do
    args <- getArgs
    let optionalArg : Maybe String = index' argNum args
    let optionalValue : Maybe Int = optionalArg >>= (parseInteger { a=Int })
    pure $ fromMaybe defaultValue optionalValue

effectMaze : Eff () [RND, STDIO, SYSTEM]
effectMaze = do
    let defaultWidth : Int = 5
    width <- getArg 1 defaultWidth
    let defaultHeight : Int = width
    height <- getArg 2 defaultHeight
    let horzPairs: List (Int, Int) = map ( \i => (i, i + 1)) [0..(width-2)]
    let vertPairs: List (Int, Int) = map ( \i => (i, i + 1)) [0..(height-2)]
    let horzNodes: List Int = [0..width]
    let vertNodes: List Int = [0..height]
    edges <- mazeEdges horzPairs vertPairs
    let cellPair: (Int -> Int -> String) = \i, j =>
        "<" ++ (show i) ++ "," ++ (show j) ++ ">"
--    putStrLn "Grid: (cell squares)"
--    showGrid horzNodes vertNodes cellPair
    let hFlag = \i : Int, j : Int =>
        elem ((i - 1, j), (i, j)) edges
    let vFlag = \i : Int, j : Int =>
        elem ((i, j - 1), (i, j)) edges
    let cellFlags: (Int -> Int -> String) = \i, j =>
        " " ++
        (if (hFlag i j) then "T" else "F") ++
        (if (vFlag i j) then "T" else "F")
--    putStrLn "Grid: (not)"
--    showGrid horzNodes vertNodes cellFlags
    let cellQSquare: (Int -> Int -> String) = \i, j =>
        let hEnd = (i == width)
            vEnd = (j == height) in
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
    showGrid horzNodes vertNodes cellQSquare
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

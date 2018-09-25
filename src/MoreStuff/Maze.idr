module MoreStuff.Maze

import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Effect.Monad
import Control.IOExcept
import Data.Vect

import MoreStuff.GodelPerm
import MoreStuff.GraphAlgo

-- qSquare = "▖▗▘▙▚▛▜▝▞▟"
qSquare: String
qSquare = " ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█"

rndPerm : Vect n a -> Eff (Vect n a) [RND]
rndPerm {n=n} vs = do
    code <- rndInt 0 (factorial n)
    let perm = godelPerm n code
    let shuffled = map (\i => index i vs) perm
    pure shuffled

shuffle : List a -> Eff (List a) [RND]
shuffle xs = do
    vs <- rndPerm (fromList xs)
    pure $ toList vs

joinStrings: List String -> String
joinStrings = pack . concat . (map unpack)

generateMaze : Eff () [RND, STDIO, SYSTEM]
generateMaze = do
    seed <- time
    srand seed
    let order = 4
    let nodes: List Int = [0..(order-2)]
    let graph: List ((Int, Int), (Int, Int)) = do
        i <- nodes
        j <- nodes
        k <- [((i, j), (i + 1, j)), ((i, j), (i + 1, j))]
        pure k
    rgraph <- shuffle graph
    let edges = spanningForest rgraph
    putStrLn $ show edges
    let k: List (Eff () [STDIO]) = map putStrLn ["Ho", "ho"]
--    let kk: (Eff (List ()) [STDIO]) = sequence k
    let line : (Int -> String) = \i =>
        joinStrings $ do
            j <- nodes
            pure $ "<" ++ (show i) ++ "," ++ (show j) ++ ">"
--        j <- nodes
--        pure $ "<" ++ (show i) ++ "," ++ (show j) ++ ">"
    let lines : List String = do
        i <- nodes
        pure (line i)
    putStr $ unlines lines
    pure ()
--    putStrLn $ show (spanningForest fudges)
--    value <- rndPerm ["V", "X", "Y", "Z", "."]
--    putStrLn (show value)



export
doMaze : IO ()
doMaze = do run generateMaze


--- experiments with monadic effects:

experiment : MonadEff [RND, STDIO, SYSTEM] ()
experiment = monadEffT generateMaze

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

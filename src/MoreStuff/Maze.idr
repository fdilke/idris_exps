module MoreStuff.Maze

import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Control.IOExcept
import Data.Vect

import MoreStuff.GodelPerm

rndPerm : Vect n a -> Eff (Vect n a) [RND]
rndPerm {n=n} vs = do
    code <- rndInt 0 (factorial n)
    let perm = godelPerm n code
    let shuffled = map (\i => index i vs) perm
    pure shuffled

generateMaze : Eff () [RND, STDIO, SYSTEM]
generateMaze = do
    seed <- time
    srand seed
    let order = 3
    let edges: List ((Int, Int), (Int, Int)) = [((0, 0), (0, 1)), ((0, 0), (1, 0))]
    let nodes: Vect _ Int = fromList [0..(order-2)]
    let bodges: Vect _ ((Int, Int), (Int, Int)) = do
        i <- nodes
        j <- nodes
        k <- [((i, j), (i + 1, j)), ((i, j), (i + 1, j))]
        pure k
    fudges <- rndPerm bodges
    putStrLn $ show fudges
    value <- rndPerm ["V", "X", "Y", "Z", "."]
    putStrLn (show value)

export
doMaze : IO ()
doMaze = do run generateMaze



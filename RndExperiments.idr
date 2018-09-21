module Main

import src.MoreStuff.GodelPerm
import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Control.IOExcept
import Data.Vect

--rndMessage : Eff String [RND]
--rndMessage = do
--    msg <- rndSelect' ["Hello", "Goodbye", "Arriverderci"]
--    pure msg

rndPerm : Vect n a -> Eff (Vect n a) [RND]
rndPerm {n=n} vs = do
    code <- rndInt 0 (factorial n)
    let perm = godelPerm n code
    let shuffled = map (\i => index i vs) perm
    pure shuffled

testRandom : Eff () [RND, STDIO, SYSTEM]
testRandom = do
    seed <- time
    srand seed
    value <- rndPerm ["V", "X", "Y", "Z"]
    putStrLn (show value)

main : IO ()
main = do run testRandom

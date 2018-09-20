module Main

import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Control.IOExcept
import Data.Vect

rndMessage : Eff String [RND]
rndMessage = do
    msg <- rndSelect' ["Hello", "Goodbye", "Arriverderci"]
    pure msg

rndPerm : Vect (S n) a -> Eff (Vect (S n) a) [RND]
rndPerm {n=n} vs = do
    pure vs

testRandom : Eff () [RND, STDIO, SYSTEM]
testRandom = do
    seed <- time
    srand seed
--    value <- rndInt 0 100
--    value <- rndMessage
    value <- rndPerm ["Bob", "Hob", "Fob"]
    putStrLn (show value)

main : IO ()
main = do run testRandom

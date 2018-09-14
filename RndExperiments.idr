module Main

import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Control.IOExcept

testRandom : Eff () [RND, STDIO, SYSTEM]
testRandom = do
    seed <- time
    srand seed
    value <- rndInt 0 100
    putStrLn (show value)

main : IO ()
main = do run testRandom

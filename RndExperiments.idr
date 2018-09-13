module FileExperiments

import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Control.IOExcept

TestRnd : Type -> Type -> Type
TestRnd st t = Eff t [RND, STDIO, SYSTEM]

testRandom : TestRnd () ()
testRandom = do
    seed <- time
    srand seed
    value <- rndInt 0 10
    putStrLn (show value)

main : IO ()
main = run testRandom

module Main

import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Effect.Select
import Effect.Exception
import Effect.Monad
import Control.IOExcept

TestRnd : Type -> Type
TestRnd t = Eff t [RND, SYSTEM, STDIO]

testRandom : TestRnd ()
testRandom = (do
    seed <- time
    srand seed
--    i <- select ["x", "y", "z"]
    value <- rndInt 0 100
    let range = the (List Int) [1..10]
    let yy: (Eff () [STDIO]) = handle value 0
    let zz: (List (Eff () [STDIO])) = map (handle value) range
--    let vv = run yy
    handle value 0
    --    sequence (map (handle value) range)
--    sequence $ map (lift . Effect.StdIO.putStrLn) ["It", "works", "now"]
    pure ()
    ) where
        handle: Integer -> Int -> Eff () [STDIO]
        handle value i = putStrLn (show value)

triple : Int -> Eff (Int, Int, Int) [SELECT, EXCEPTION String]
triple max = do z <- select [1..max]
                y <- select [1..z]
                x <- select [1..y]
                if (x * x + y * y == z * z)
                   then pure (x, y, z)
                   else raise "No triple"

main : IO ()
main = do run testRandom
-- main = do print $ the (List _) $ runInit [] testRandom

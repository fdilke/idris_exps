module MoreStuff.ShowBadRndInt

import Effects
import Effect.State
import Effect.StdIO
import Effect.Random
import Effect.System
import Effect.Monad
import Control.IOExcept
import Data.Vect
import Data.String


effectBadRndInt : Eff () [RND, STDIO, SYSTEM]
effectBadRndInt = do
    srand !time
    let range : Integer = 10000000000000000
    sample <- rndInt 0 range
    putStrLn $ "sample: " ++ (show sample)

rndFact : Nat -> Eff Integer [RND]
rndFact Z = pure 0
rndFact (S n) = do
    prevFact <- (rndFact n)
    let n1 = toIntegerNat $ S n
    shift <- rndInt 0 n1
--    putStrLn $ "shift: " ++ (show shift) ++ " from: " ++ (show n1)
    pure $ n1 * prevFact + shift

--    rndInt 0 3


effectGoodRndInt : Eff () [RND, STDIO, SYSTEM]
effectGoodRndInt = do
    srand !time
    args <- getArgs
    let defaultOrder : Int = 3
    let optionalOrder = index' 1 args >>= (parseInteger { a=Int })
    let order = fromMaybe defaultOrder optionalOrder
    sample <- rndFact $ toNat order
    putStrLn $ "rndFact sample: " ++ (show sample)


export
doShowBadRndInt : IO ()
doShowBadRndInt = do run effectGoodRndInt

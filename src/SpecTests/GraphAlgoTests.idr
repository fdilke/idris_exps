module SpecTests.GraphAlgoTests

import MoreStuff.GraphAlgo
import Specdris.Spec
import Specdris.Expectations
import Data.Fin
import Data.Vect

Show (Fin len) where
    show = show . finToNat

export
graphAlgoTests: SpecTree
graphAlgoTests = let
    xxx = 3
    yyy = "Holloe" in
    describe "Graph algorithms" $ do
--        it "bob-a-job" $ do
--            0 `shouldBe` 0
        describe "Iterate-to-fixed works for ..." $ do
            it "a countdown to 0" $ do
                let conditionalDec = \n: Int =>
                    if (n > 0) then (n - 1) else n
                iterateToFixed conditionalDec 6 `shouldBe` 0
        describe "Calculating equivalence relations works for ..." $ do
            it "an empty set" $ do
                buildEquiv 0 [] `shouldBe` []
            it "a singleton with no relators" $ do
                let ee: List (Fin 1, Fin 1) = []
                buildEquiv 1 ee `shouldBe` [0]
            it "a doubleton with no relators" $ do
                buildEquiv 2 [] `shouldBe` [0,1]
            it "a doubleton with only trivial relators" $ do
                buildEquiv 2 [(0, 0), (1, 1)] `shouldBe` [0,1]
--            it "a doubleton, equating its elements" $ do
--                buildEquiv 2 [(0, 1)] `shouldBe` []



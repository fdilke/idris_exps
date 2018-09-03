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
            it "a doubleton, equating its elements" $ do
                buildEquiv 2 [(0, 1)] `shouldBe` [1,1]
            it "a nontrivial example" $ do
                buildEquiv 4 [(1, 2)] `shouldBe` [0,2,2,3]
            it "a bigger example" $ do
                buildEquiv 6 [(1, 2), (2, 3)] `shouldBe` [0,3,3,3,4,5]
            it "a yet bigger example" $ do
                buildEquiv 10 [
                    (1, 2), (7, 0), (4, 3), (3, 7), (6, 5), (9, 5)
                ] `shouldBe` [
                    0, 2, 2, 0, 0, 5, 5, 0, 8, 5
                ]
            it "a formerly problematic example" $ do
                buildEquiv 4 [
                    (3, 3), (2, 2), (0, 2), (1, 3), (3, 3), (2, 2), (3, 1), (2, 0)
                ] `shouldBe` [
                    0, 1, 0, 1
                ]
            it "another formerly problematic example" $ do
                buildEquiv 4 [
                    (3, 3), (3, 2), (3, 1), (3, 0), (2, 3), (2, 2), (2, 1), (2, 0),
                    (1, 3), (1, 2), (1, 1), (1, 0), (0, 3), (0, 2), (0, 1), (0, 0)
                ] `shouldBe` [
                    3, 3, 3, 3
                ]
        describe "Detecting forests ..." $ do
            it "works for an empty set" $ do
                isForest (the (List (Int, Int)) []) `shouldBe` True





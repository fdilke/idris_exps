module SpecTests.GraphAlgoTests

import MoreStuff.GraphAlgo
import Specdris.Spec
import Specdris.Expectations

export
graphAlgoTests: SpecTree
graphAlgoTests = let
    t = 0
    u = 7
    list = [1,2,3] in
    describe "Graph algorithms" $ do
        describe "Iterate-to-fixed works for ..." $ do
            it "a countdown to 0" $ do
                let conditionalDec = \n: Int =>
                    if (n > 0) then (n - 1) else n
                iterateToFixed 6 conditionalDec `shouldBe` 0
        describe "Calculating equivalence relations works for ..." $ do
            it "an empty set" $ do
                buildEquiv 0 [] `shouldBe` []
            it "a singleton with no relators" $ do
                buildEquiv 1 [] `shouldBe` [0]
            it "a doubleton with no relators" $ do
                buildEquiv 2 [] `shouldBe` [0,1]
            it "a doubleton with only trivial relators" $ do
                buildEquiv 2 [(0, 0), (1, 1)] `shouldBe` [0,1]
--            it "a doubleton, equating its elements" $ do
--                buildEquiv 2 [(0, 1)] `shouldBe` []

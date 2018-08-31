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
        describe "Calculating equivalence relations works for ..." $ do
            it "an empty set" $ do
                buildEquiv 0 [] `shouldBe` []

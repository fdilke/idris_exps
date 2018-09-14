module SpecTests.GodelPermTests

import MoreStuff.GodelPerm
import Specdris.Spec
import Specdris.Expectations
import Data.Fin
import Data.Vect
import Data.SortedMap
import Helpers.Implementations

export
godelPermTests: SpecTree
godelPermTests =
    describe "Godel numbered permutations" $ do
        describe "work for ..." $ do
            it "empty lists" $ do
                godelPerm 0 6 `shouldBe` []
            it "one-element lists" $ do
                godelPerm 1 3 `shouldBe` [0]

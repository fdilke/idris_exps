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
    describe "Godel numbered permutations:" $ do
        describe "The permutations work for ..." $ do
            it "empty lists" $ do
                godelPerm 0 6 `shouldBe` []
            it "one-element lists" $ do
                godelPerm 1 3 `shouldBe` [0]
            it "two-element lists" $ do
                godelPerm 2 0 `shouldBe` [1, 0]
                godelPerm 2 1 `shouldBe` [0, 1]
            it "three-element lists" $ do
                map (godelPerm 3) [0..5] `shouldBe` [
                    [2, 1, 0],
                    [1, 2, 0],
                    [1, 0, 2],
                    [2, 0, 1],
                    [0, 2, 1],
                    [0, 1, 2]
                ]
        describe "factorials" $ do
            it "work as described" $ do
                let expected : Vect 3 Integer = [1, 1, 5040]
                factorial <$> [0, 1, 7] `shouldBe` expected


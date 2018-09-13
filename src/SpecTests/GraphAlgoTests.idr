module SpecTests.GraphAlgoTests

import MoreStuff.GraphAlgo
import Specdris.Spec
import Specdris.Expectations
import Data.Fin
import Data.Vect
import Data.SortedMap

Show (Fin len) where
    show = show . finToNat

(Show k, Show v) => Show (SortedMap k v) where
    show = show . toList

(Eq k, Eq v) => Eq (SortedMap k v) where
    (==) xs ys = (toList xs) == (toList ys)

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
        describe "Detecting circuits works for ..." $ do
            it "an empty set" $ do
                hasCycle (the (List (Int, Int)) []) `shouldBe` False
            it "a single edge" $ do
                hasCycle [(1, 2)] `shouldBe` False
            it "a single loop" $ do
                hasCycle [(1, 1)] `shouldBe` True
            it "a pair of complementary edges" $ do
                hasCycle [(1, 2), (2, 1)] `shouldBe` True
            it "a more complex tree" $ do
                hasCycle [(0, 4), (1, 4), (2, 4), (4, 5), (4, 6)] `shouldBe` False
            it "a yet more complex tree" $ do
                hasCycle [(0, 1), (2, 3), (4, 5), (1, 3), (5, 2)] `shouldBe` False
            it "a yet more complex graph with cycle" $ do
                hasCycle [(0, 1), (2, 3), (4, 5), (1, 3), (5, 2), (0, 4)] `shouldBe` True
        describe "Joining disjoint sets works for ..." $ do
            let sortedMap = Data.SortedMap.fromList
            it "equal nodes on an empty set" $ do
                let set = sortedMap $ the (List (Int, Int)) []
                let expected = sortedMap [(1, 1)]
                join set 1 1 `shouldBe` (True, expected)
            it "unequal nodes on an empty set" $ do
                let set = sortedMap $ the (List (Int, Int)) []
                let expected = sortedMap [(1, 1), (2, 2)]
                join set 1 2 `shouldBe` (False, expected)
            it "equal existing nodes on an inhabited set" $ do
                let set = sortedMap [(1, 2), (2, 2)]
                join set 1 1 `shouldBe` (True, set)
            it "unequal existing nodes on an inhabited set" $ do
                let set = sortedMap [(1, 1), (2, 2)]
                let expected = sortedMap [(1, 2), (2, 2)]
                join set 1 2  `shouldBe` (False, expected)
            it "an existing node and a new one on an inhabited set" $ do
                let set = sortedMap [(1, 1)]
                let expected = sortedMap [(1, 1), (2, 1)]
                join set 1 2  `shouldBe` (False, expected)
            it "a new node and an existing one on an inhabited set" $ do
                let set = sortedMap [(1, 1)]
                let expected = sortedMap [(1, 1), (2, 1)]
                join set 2 1  `shouldBe` (False, expected)
        describe "Spanning tree algorithm works for ..." $ do
            it "an empty graph" $ do
                let graph: List (Int, Int) = []
                spanningTree graph `shouldBe` graph





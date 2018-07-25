module SpecTests.EnumerationTests

import MoreStuff.Enumerations
import Specdris.Spec
import Specdris.Expectations

export
enumerationTests: SpecTree
enumerationTests = let
    t = 0
    u = 7
    list = [1,2,3]
    enum = listAsEnum list in
        describe "Enumerations" $ do
            it "are interchangeable with lists" $ do
                enumAsList enum `shouldBe` list
            it "are showable" $ do
                show enum `shouldBe` "[1, 2, 3]"
            it "are foldable" $ do
                let fold = foldr (+) 0 enum
                fold `shouldBe` 6
            it "are functorial" $ do
                enumAsList((*2) <$> enum) `shouldBe` [2,4,6]

-- todo: inherit Show, Functor, Eq, Traversable, How about Applicative?
-- todo: make Enumeration a monad



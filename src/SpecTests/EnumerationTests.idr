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
    enum = makeEnum list in
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
            it "are applicative" $ do
                enumAsList(pure 3) `shouldBe` [3]
                let hof = makeEnum [(*2), (*3)]
                enumAsList(hof <*> enum) `shouldBe` [2,3,4,6,6,9]
            it "can be joined" $ do
                let enum2 = makeEnum [4,5,6]
                enumAsList (enum ++ enum2) `shouldBe`
                    [1,2,3,4,5,6]
            it "feature an empty enum" $ do
                let hubber = emptyEnum
                let bubber = enumAsList hubber
                0 `shouldBe` 1
                -- (enumAsList emptyEnum) `shouldBe` []
{-
            it "are traversable" $ do
                let a_fb = \x => Just (x + 1)   -- can we use where?
                traverse a_fb enum `shouldBe` (Just [2,3,4])

Maybe start by defining : to join two Enums. Then:
have to turn an Enum(f b) into an f( Enum b) for Applicative f
do it by mapping f over ::, then applying this to all the fb;s
having first turned them into f(Enum b)'s by mapping over pure!
-}

-- todo: inherit Traversable, how about Eq?
-- todo: make Enumeration a monad



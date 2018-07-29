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
                let ee: (Enumeration Int) = emptyEnum
                enumAsList ee `shouldBe` []
            it "are traversable" $ do
                let a_fb = \x => Just (x + 1)   -- can we use where?
                let t_out = traverse a_fb enum
                let mapped: Maybe (List Int) = map enumAsList t_out
                mapped `shouldBe` (Just [2,3,4])
            it "support head/tail/::" $ do
                head (the (Enumeration Int) emptyEnum)
                    `shouldBe` Nothing
                head enum `shouldBe` Just 3
                map enumAsList (tail enum) `shouldBe`
                    Just [1, 2]
                enumAsList (0 :: enum) `shouldBe` [0,1,2,3]
            it "support equality testing" $ do
                enum `shouldBe` enum
                enum `shouldNotBe` (1 :: enum)
                enum `shouldNotBe` emptyEnum
                enum `shouldNotBe` (enum ++ enum)
            it "support monad binding" $ do
                let f = \x => makeEnum [0, x]
                let bound = enum >>= f
                enumAsList bound `shouldBe` [0,1,0,2,0,3]
            it "support monad join" $ do
                let enum2 = map (+3) enum
                let joined = join (makeEnum [enum, enum2])
                enumAsList joined `shouldBe` [1,2,3,4,5,6]

-- todo: inherit Traversable, how about Eq?
-- todo: make Enumeration a monad. Add Alternative



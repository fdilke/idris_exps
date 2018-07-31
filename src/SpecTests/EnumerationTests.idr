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
            it "support equality testing" $ do
                enum `shouldBe` enum
                enum `shouldNotBe` (1 :: enum)
                enum `shouldNotBe` empty
                enum `shouldNotBe` (enum ++ enum)
            it "are interchangeable with lists" $ do
                enumAsList enum `shouldBe` list
            it "are showable" $ do
                show enum `shouldBe` "[1, 2, 3]"
            it "are foldable" $ do
                let fold = foldr (+) 0 enum
                fold `shouldBe` 6
            it "are functorial" $ do
                (*2) <$> enum `shouldBe` (makeEnum [2,4,6])
            it "are applicative" $ do
                pure 3 `shouldBe` (makeEnum [3])
                let hof = makeEnum [(*2), (*3)]
                hof <*> enum `shouldBe` (makeEnum [2,3,4,6,6,9])
            it "can be joined" $ do
                let enum2 = makeEnum [4,5,6]
                enum ++ enum2 `shouldBe`
                    (makeEnum [1,2,3,4,5,6])
            it "feature an empty enum" $ do
                let ee: (Enumeration Int) = empty
                ee `shouldBe` (makeEnum [])
            it "are traversable" $ do
                let a_fb = \x => Just (x + 1)   -- can we use where?
                let t_out = traverse a_fb enum
                t_out `shouldBe` (Just (makeEnum [2,3,4]))
            it "support head/tail/::" $ do
                head (the (Enumeration Int) empty)
                    `shouldBe` Nothing
                head enum `shouldBe` Just 3
                tail enum `shouldBe`
                    Just (makeEnum [1, 2])
                0 :: enum `shouldBe` (makeEnum [0,1,2,3])
            it "support monad binding" $ do
                let f = \x => makeEnum [0, x]
                enum >>= f `shouldBe`
                    (makeEnum [0,1,0,2,0,3])
            it "support monad join" $ do
                let enum2 = map (+3) enum
                join (makeEnum [enum, enum2]) `shouldBe`
                    (makeEnum [1,2,3,4,5,6])
            it "support list comprehensions via Alternative" $ do
                empty `shouldBe` (the (Enumeration Int) (makeEnum []))
                enum <|> enum `shouldBe` (makeEnum [1,2,3,1,2,3])
                [ x*x | x <- enum, x < 3 ] `shouldBe`
                    (makeEnum [1, 4])

-- todo: inherit Traversable, how about Eq?
-- todo: make Enumeration a monad. Add Alternative
-- refactor so we establish Eq and then use it, don't need enum2list

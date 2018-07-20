module SpecTests.NoddyTests

import Specdris.Spec

double : Num a => a -> a
double a = a + a

triple : Num a => a -> a
triple a = a + double a

export
basicTests: SpecTree
basicTests =
    describe "Basic tests" $ do
      it "fulfils xx" $ do
        (double 2) `shouldBe` 4
        (triple 2) `shouldNotBe` 5

export
noddyMathTests: SpecTree
noddyMathTests =
    describe "This is my math test" $ do
      it "adds two natural numbers" $ do
        (1 + 1) `shouldBe` 2
  --    it "multiplies two natural numbers" $ do
  --      (2 * 2) `shouldBe` 3
      it "do fancy stuff with complex numbers" $ do
        pendingWith "do this later"

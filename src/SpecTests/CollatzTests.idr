module SpecTests.CollatzTests

import MoreStuff.Collatz
import Specdris.Spec

export
collatzTests: IO ()
collatzTests = spec $ do
  describe "Tests with Collatz iterations!" $ do
    it "does a single iterate" $ do
      (collatz_iterate 1) `shouldBe` 4
      (collatz_iterate 2) `shouldBe` 1
      (collatz_iterate 3) `shouldBe` 10
    it "counts how many are required" $ do
      (collatz_iterations 1 0) `shouldBe` 0
      (collatz_iterations 3 0) `shouldBe` 7

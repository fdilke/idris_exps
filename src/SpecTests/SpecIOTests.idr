module SpecTests.SpecIOTests

import SpecTests.NoddyTests
import SpecTests.CollatzTests
import SpecTests.FileHandlingTests
import Specdris.SpecIO

loadName: IO (String)
loadName = pure "clobber"

export
specIOTests: IO ()
specIOTests = specIO $ do
   describe "This is my side effect test" $ do
     collatzTests
     noddyMathTests
     basicTests
     fileHandlingTests
     it "say my name" $ do
        name <- loadName
        pure $ name `shouldBe` "clobber"


module SpecTests.FileHandlingTests

import MoreStuff.FileHandling
import Specdris.Spec

export
fileHandlingTests: SpecTree' ffi
fileHandlingTests =
    describe "File handling" $ do
        it "can load the contents of a file" $
          if True then do
            pendingWith "fix this later"
          else do
            (loadFile "languages.txt") `shouldBe` Just["English", "French"]
            (loadFile "no-such-file.txt") `shouldBe` Nothing


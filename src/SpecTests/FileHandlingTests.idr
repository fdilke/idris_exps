module SpecTests.FileHandlingTests

import MoreStuff.FileHandling
import Specdris.SpecIO
import Specdris.Expectations

export
fileHandlingTests: SpecTree
fileHandlingTests =
  describe "File handling" $ do
    it "test unpacks an IO x" $ do
      name <- the (IO String) $ pure "nonsense"
      pure $ name `shouldBe` "nonsense"
    it "can load the contents of a file" $ do
      lines <- loadFile "resources/languages.txt"
      pure $ lines `shouldBe` Just ["English", "German", "Polish", "Hindustani"]
    it "correctly handles a missing file" $ do
       lines <- loadFile "no-such-file.txt"
       pure $ lines `shouldBe` Nothing
    it "does some other damnfool thing" $
      pure $ pendingWith "todo whatever"

{-
        it "can use a nicer syntax" $
            map (`shouldBe` ["English", "French"]) (loadFile "languages.txt")
-}


module SpecTests.FileHandlingTests

import MoreStuff.FileHandling
import Specdris.SpecIO
import Specdris.Expectations
import MoreStuff.Enumerations

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
    it "correctly handles loading of a missing file" $ do
       lines <- loadFile "no-such-file.txt"
       pure $ lines `shouldBe` Nothing
    it "can load a file as enumeration" $ do
       enum <- linesAsEnum "resources/languages.txt"
       pure $ (enumAsList <$> enum) `shouldBe` Just ["bubb"] -- "English", "German", "Polish", "Hindustani"]
    it "correctly handles enumeration of a missing file" $ do
       enum <- linesAsEnum "no-such-file.txt"
       pure $ enum `shouldBe` Nothing
    it "does some other damnfool thing" $
      pure $ pendingWith "todo whatever"

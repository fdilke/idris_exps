module SpecTests.LiteRegexTests

import MoreStuff.LiteRegex
import Specdris.Spec
import Specdris.Expectations
import Data.Fin
import Data.Vect
import Data.SortedMap
import Helpers.Implementations

pattern: Vect 2 String
pattern = [ "::", "/" ]

export
liteRegexTests: SpecTree
liteRegexTests =
    describe "Lite regex matching:" $ do
        describe "Matching works when ..." $ do
            it "dummy" $ do
                pendingWith "fix these ..."
--            it "there is no match at all" $ do
--                liteRegex pattern "hooey" `shouldBe` Nothing
--            it "there is a partial match" $ do
--                liteRegex pattern "hooey::pooey" `shouldBe` Nothing
--            it "there is a complete match" $ do
--                liteRegex pattern "hooey::pooey/cooey" `shouldBe` ( Just [ "hooey", "pooey", "cooey"] )


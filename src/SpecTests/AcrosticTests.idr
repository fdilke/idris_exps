module SpecTests.AcrosticTests

import MoreStuff.Acrostic
import Specdris.Spec

export
acrosticTests: SpecTree
acrosticTests =
    describe "Acrostic tests" $ do
        let words = [ "ook", "awk", "irk", "eek" ]
        it "checks if the columns are words" $ do
          (wordsDown 3 words [ "oai", "owr", "kkk" ]) `shouldBe` True
          (wordsDown 3 words [ "oai", "owr", "xkk" ]) `shouldBe` False
          (wordsDown 3 words [ "oai", "xwr", "kkk" ]) `shouldBe` False
          (wordsDown 3 words [ "xai", "owr", "kkk" ]) `shouldBe` False
        it "more stuff" $ do
            pendingWith "do this later"
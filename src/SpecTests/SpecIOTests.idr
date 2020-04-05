module SpecTests.SpecIOTests

import SpecTests.NoddyTests
import SpecTests.CollatzTests
import SpecTests.AcrosticTests
import SpecTests.FileHandlingTests
import SpecTests.EnumerationTests
import SpecTests.GraphAlgoTests
import SpecTests.GodelPermTests
import SpecTests.LiteRegexTests
import Specdris.SpecIO

export
specIOTests: IO ()
specIOTests = specIO $
     describe "All Tests" $ do
       collatzTests
       noddyMathTests
       basicTests
       fileHandlingTests
       enumerationTests
       acrosticTests
       graphAlgoTests
       godelPermTests
       liteRegexTests

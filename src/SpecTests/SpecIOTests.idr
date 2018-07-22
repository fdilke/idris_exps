module SpecTests.SpecIOTests

import SpecTests.NoddyTests
import SpecTests.CollatzTests
import SpecTests.FileHandlingTests
import SpecTests.EnumerationTests
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

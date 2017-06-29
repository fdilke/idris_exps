module AltTest.Tests

double : Num a => a -> a
double a = a + a

triple : Num a => a -> a
triple a = a + double a

-- and the tests

assertEq : Eq a => (given : a) -> (expected : a) -> IO ()
assertEq g e = if g == e
    then putStrLn "Test Passed"
    else putStrLn "Test Failed"

assertNotEq : Eq a => (given : a) -> (expected : a) -> IO ()
assertNotEq g e = if not (g == e)
    then putStrLn "Test Passed"
    else putStrLn "Test Failed"

export
testDouble : IO ()
testDouble = assertEq (double 2) 4

export
testTriple : IO ()
testTriple = assertNotEq (triple 2) 5

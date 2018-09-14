module Main

main : IO ()
main = do
    let values = map show [1, 2, 3]
    sequence $ map putStrLn values
    pure()


--    sequence $ map (\_ => run testRandom) [0..10]
--    pure ()

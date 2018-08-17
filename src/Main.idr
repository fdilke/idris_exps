module Main

import Lib
import MoreStuff.FileHandling
import MoreStuff.Acrostic

{-
main : IO ()
main = do
  putStrLn "In the MAIN entry point"
  someFun
  pure ()
-}

{-}
main : IO ()
main = do
  optionalLines <- loadFile "/tmp/botch.txt" -- "/usr/share/dict/words"
  let words = fromMaybe [] optionalLines
  putStrLn "=== words end"
  pure ()
-}

mwhile : (test : IO Bool) -> (body : IO ()) -> IO ()
mwhile t b = do v <- t
                case v of
                     True => do b
                                mwhile t b
                     False => pure ()

dumpFile : String -> IO ()
dumpFile fn = do { Right h <- openFile fn Read
                   mwhile (do { -- putStrLn "TEST"
                                x <- fEOF h
                                pure (not x) })
                          (do { Right l <- fGetLine h
                                putStr l })
                   closeFile h }
{-
main : IO ()
main = do
  dumpFile "/tmp/botch.txt"
  pure ()
-}

findAcrostics : List String -> IO ()
findAcrostics words = do
    putStr $ (show (length words) ++ " words!!")
    let triples = [ (w1, w2, w3) |
        w1 <- words,
        w2 <- words,
        w3 <- words,
        wordsDown 3 words [ w1, w2, w3 ]
    ]
    putStr $ show triples

main : IO ()
main = do
  text <- loadFile2 "src/resources/ThreeLetterWords.txt"
  case text of
    Just lines => let
        trimmedLines = ((toUpper . trim) <$> lines)
        words = [ word | word <- trimmedLines, length word == 3 ] in
        findAcrostics words
  pure ()



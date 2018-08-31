module MoreStuff.Acrostic

import MoreStuff.FileHandling

export
wordsDown : Int -> List String -> List String -> Bool
wordsDown length dictionary rows =
    all wordAtColumn [0..(length - 1)] where
    wordAtColumn column = let
        nth = \word => strIndex word column
        letters = nth <$> rows
        column = pack letters in
            elem column dictionary

-- todo: make all this work with Vect rather than List

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

export
doAcrostics : IO ()
doAcrostics = do
  text <- loadFile "src/resources/ThreeLetterWords.txt"
  case text of
    Just rawLines => let
        lines = ((toUpper . trim) <$> rawLines)
        words = [ word | word <- lines, length word == 3 ] in
        findAcrostics words
  pure ()



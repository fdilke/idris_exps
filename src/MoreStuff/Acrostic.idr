module MoreStuff.Acrostic

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


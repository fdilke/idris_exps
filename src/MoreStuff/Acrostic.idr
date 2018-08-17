module MoreStuff.Acrostic

export
wordsDown : Int -> List String -> List String -> Bool
wordsDown length dictionary rows =
    all wordAtColumn [0..(length - 1)] where
    wordAtColumn col =
        elem column dictionary where
        column = pack $ (\word => strIndex word col) <$> rows


-- todo: make all this work with Vect rather than List


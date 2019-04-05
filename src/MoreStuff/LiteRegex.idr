module MoreStuff.LiteRegex

import Data.Fin
import Data.Vect
import Data.SortedMap

export
liteRegex: Vect len String -> String -> Maybe (Vect (S len) String)
liteRegex [] text = Just $ [ text ]
liteRegex (x :: xs) text = Just $ insertAt 0 text (x :: xs)

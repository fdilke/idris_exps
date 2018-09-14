module Helpers.Implementations

import Data.Fin
import Data.Vect
import Data.SortedMap

%access public export

Show (Fin len) where
    show = show . finToNat

(Show k, Show v) => Show (SortedMap k v) where
    show = show . toList

(Eq k, Eq v) => Eq (SortedMap k v) where
    (==) xs ys = (toList xs) == (toList ys)

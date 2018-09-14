module MoreStuff.GodelPerm

import Data.Fin
import Data.Vect

export
godelPerm: (len: Nat) -> Integer -> Vect len (Fin len)
godelPerm len number = range


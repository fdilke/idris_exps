module MoreStuff.GodelPerm

import Data.Fin
import Data.Vect

export
godelPerm: (len: Nat) -> Integer -> Vect len (Fin len)
godelPerm Z number = range
godelPerm (S n) number = let
    index: Fin (S n) = restrict n number
    length: Integer = 1 + toIntegerNat n
    simpler: Vect n (Fin n) = godelPerm n (div number length) in
        insertAt index last $ map weaken simpler


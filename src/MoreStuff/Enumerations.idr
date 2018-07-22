module MoreStuff.Enumerations

-- interface (Foldable f) => Enumeration (f : Type) where

export data Enumeration: (elem: Type) -> Type where
    FoldableEnum : Foldable t => (x : t a) -> Enumeration a

export
listAsEnum: List a -> Enumeration a
listAsEnum xs = FoldableEnum xs

export
enumAsList: Enumeration a -> List a
enumAsList (FoldableEnum f) = foldr (::) [] f

-- export implementation Show
--  partial
--  showPrec : (d : Prec) -> (x : ty) -> String
--  showPrec _ x = show x

export Show a => Show (Enumeration a) where
  show enum = show (enumAsList enum)

export Foldable Enumeration where
  foldr func acc (FoldableEnum f) =
    foldr func acc f

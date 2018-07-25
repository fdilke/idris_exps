module MoreStuff.Enumerations

%access public export

-- interface (Foldable f) => Enumeration (f : Type) where

data Enumeration: (elem: Type) -> Type where
    FoldableEnum : Foldable t => (x : t a) -> Enumeration a

listAsEnum: List a -> Enumeration a
listAsEnum xs = FoldableEnum xs

enumAsList: Enumeration a -> List a
enumAsList (FoldableEnum f) = foldr (::) [] f

Show a => Show (Enumeration a) where
  show enum = show (enumAsList enum)

Foldable Enumeration where
  foldr func acc (FoldableEnum f) =
    foldr func acc f

data AMapFoldable: Type -> Type where
    MapFoldable: Foldable t => (a -> b) -> t a -> AMapFoldable b

Foldable AMapFoldable where
    foldr func acc (MapFoldable f2 xs) =
        foldr (func . f2) acc xs

Functor Enumeration where
  map func (FoldableEnum xs) = FoldableEnum (MapFoldable func xs)

data AnEnumApp: Type -> Type where
    EnumApp: Foldable t => (t (a -> b)) -> t a -> AnEnumApp b

Foldable AnEnumApp where
    foldr func acc (EnumApp enumf enuma) =
        foldr (\a, ac =>
            foldr (\f =>
                func (f a)
            ) ac enumf
        ) acc enuma

Applicative Enumeration where
  pure x = listAsEnum [x]
  enumf <*> enuma = FoldableEnum (EnumApp enumf enuma)

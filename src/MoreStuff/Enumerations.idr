module MoreStuff.Enumerations

%access public export

-- interface (Foldable f) => Enumeration (f : Type) where
{-
record Remuneration a where
     constructor MkRemuneration
     do_foldr : (b: Type) -> (func : a -> b) -> b

muni: a -> Remuneration a
muni x = MkRemuneration (\ty,f => f x)

record Degeneration a where
     constructor MkDegeneration
     do_foldr : { b: Type } -> (func : a -> b) -> b

duni: a -> Degeneration a
duni x = MkDegeneration (\f => f x)
-}

record Enumeration a where
     constructor MkEnumeration
     do_foldr : { acc: Type } -> (func : a -> acc -> acc) -> (init : acc) -> acc

-- data Enumeration: (elem: Type) -> Type where
--    FoldableEnum : Foldable t => (x : t a) -> Enumeration a

--todo: make this foldableAsEnum
makeEnum: Foldable t => t a -> Enumeration a
makeEnum xs = MkEnumeration (\f,acc => (foldr f acc xs))

enumAsList: Enumeration a -> List a
enumAsList xs = do_foldr xs (::) []

Show a => Show (Enumeration a) where
  show enum = show (enumAsList enum)

Foldable Enumeration where
  foldr func acc xs =
    do_foldr xs func acc

Functor Enumeration where
  map func xs = MkEnumeration $ \f,acc =>
    do_foldr xs (f . func) acc

Applicative Enumeration where
  pure x = MkEnumeration $ \f, acc => f x acc
  ef <*> ea = MkEnumeration $ \f, acc =>
    foldr (\a, ac =>
        foldr (\f2 =>
            f (f2 a)
        ) ac ef
    ) acc ea

infixr 7 ++
(++) : Enumeration a -> Enumeration a -> Enumeration a
(++) xs ys = MkEnumeration $ \f, acc =>
    foldr f (
        foldr f acc ys
    ) xs


{-

Traversable Enumeration where
  traverse a_fb xs = ...

interface (Functor t, Foldable t) => Traversable (t : Type -> Type) where
  ||| Map each element of a structure to a computation, evaluate those
  ||| computations and combine the results.
  traverse : Applicative f => (a -> f b) -> t a -> f (t b)
-}

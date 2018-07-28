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

emptyEnum: { a: Type } -> Enumeration a
emptyEnum {a} = MkEnumeration $ \f, acc => acc

-- hubber: Int -> Int
-- hubber (x: Int) = x + 1

--  traverse (a_fb: a -> f b) xs =
--    let acc: Enumeration (f b) = emptyEnum in

Traversable Enumeration where
  traverse {f} {a} {b} a_fb xs =
    let ee: (Enumeration b) = emptyEnum
        acc : f (Enumeration b) = pure ee in
        foldr fun acc xs where
            fun x ac = [| map pure (a_fb x) ++ ac |]
-- x: a, ac: f (E b) ; a_fb x : f b
--            foldr fun (pure (emptyEnum {f b})) xs

{-

implementation Traversable (Vect n) where
    traverse f []        = [| [] |]
    traverse f (x :: xs) = [| f x :: traverse f xs |]

interface (Functor t, Foldable t) => Traversable (t : Type -> Type) where
  ||| Map each element of a structure to a computation, evaluate those
  ||| computations and combine the results.
  traverse : Applicative f => (a -> f b) -> t a -> f (t b)
-}
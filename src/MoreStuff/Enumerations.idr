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

empty': { a: Type } -> Enumeration a
empty' {a} = MkEnumeration $ \f, acc => acc

Traversable Enumeration where
  traverse {f} {a} {b} a_fb xs =
    foldr fun (pure empty') xs where
        fun x acc = [| map pure (a_fb x) ++ acc |]

head: Enumeration a -> Maybe a
head = foldr fun Nothing where
    fun x acc = Just $
        fromMaybe x acc

tail: Enumeration a -> Maybe (Enumeration a)
tail xs = foldr fun Nothing xs where
    fun x acc =
        if isNothing acc
        then Just (MkEnumeration tailfold)
        else acc
    tailfold: (f: a -> ac -> ac) -> ac -> ac
    tailfold f c =
        fromMaybe c (foldr funn Nothing xs) where
            funn y opt =
                if isNothing opt
                then Just c
                else map (f y) opt

infixr 7 ::
(::) : a -> Enumeration a -> Enumeration a
(::) x xs = MkEnumeration $ \f, acc =>
    f x $ foldr f acc xs

Eq a => Eq (Enumeration a) where
    (==) xs ys = assert_total $
        case (head xs, head ys) of
            (Nothing, Nothing) => True
            (Nothing, Just _) => False
            (Just _, Nothing) => False
            (Just x, Just y) =>
                x == y && (tail xs == (tail ys))
-- todo: fix totality checking
-- todo: try more efficient version with concurrency

Monad Enumeration where
    join xxs = MkEnumeration $ \f, acc =>
        foldr ( \xs, cc =>
            foldr f cc xs
        ) acc xxs

Alternative Enumeration where
    empty = empty'
    (<|>) = (++)

-- todo: can we avoid defining empty' and ++ just for Traversable?

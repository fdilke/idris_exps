# Installations

- Install Atom
download zip, unzip, move to Applications

- Install Idris

  cabal update, cabal install idris. Takes ages)
  To /Users/Felix/Library/Haskell/bin

- Install Haskforce plugin. 
    Have to tell it location of executable

- or with IntelliJ plugin, you don't

# to figure out with the language

How to help the typechecker with type variables?

    { thing: Type } -> ...

seems to not really work, e.g. trying to abstract
String from monadicWhile :( It must be possible.
Solved this in the end, not sure how. Perhaps you just have to
give the typechecker a bit more help. e.g.
 
    x : Int -> List Int = xx. or {t=Int} ...?

# All these questions

How to convert between `String` and `List Char` ? *pack*

Are there exceptions in Idris? What happens if you divide by 0?

How do you even divide integers? - `mod 3 2`
Why does something like `mod 3 0` have a weird type, where it looks like
an integer but isn't one, and becomes a perenially unfinished calculation??

Note `(the Nat 2) - (the Nat 4)` gives a type failure. 
What happens at run time?

How are functions declared infix, e.g. +, -, <?
How can you tell what types e.g. 3 can be cast to?


----------- found a 3 x 3 acrostic

A C E

D O G

D O O

-------------- making conversions

The "the" function is your friend:

    map S (the (List Nat) [1,2,3])

---- handy for debugging code that uses random numbers

    for i in $(seq 40) ; do ./idris_exps 1 ; sleep $[ ( $RANDOM % 10 )  + 1 ]s ; done
    
-- Strings vs lists of characters

    let bobbin : String =
        let text : (List Char) = [ 'b', 'o' ] in
            pack text
    
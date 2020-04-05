# REPL

## The `the` function - type inference
    :let t = the Nat 2
    
Define a variable `t` which is the natural number version of 2! 
You can then calculate `S t` as 3. There is no successor of int!
Also `:unlet` to erase a previous definition.

Can also use `cast` while telling which type to infer:

    the Integer (cast 9.9)

or to create an integer vector of length 0:
(note have to `:l` in a file importing Data.Vect)

    the (Vect 0 Int) Nil
    :let myempty: Vect 0 Int ; myempty = Nil
    
(You HAVE to use type inference, which then limits the scope)    
    
Defining a new variable of a given type

    :let u : String = "hubber"
    
Defining a function in one line:

    :let myfun: Int -> Int ; myfun x = x + 1
    
Using a lambda

    :let funfun: Int -> Int ; funfun = (\a => a + 1)
    
Using if-then-else. Like Scala. 
Apparently this maps to a function ifThenElse which uses Lazy x

    if funfun(2) /= 3 then "Yes" else "No"            
    
Loading in a file with a more elaborate function in it
Given scratch.idr with:

    mumble: Int -> Int
    mumble x = x + 17
    
can go:

    :l scratch.idr
    mumble 22

Can keep reloading files, so this is a bearable repl.

Can optionally name function parameters, which is handy if you want to
refer to them, e.g. for dependent types:

    humble: (value: Int) -> Int
    humble q = q * q
    (can't give a decent example yet)

Redefining a variable, use `:unlet` :
    :let qq : Maybe Integer ; qq = Nothing
    :unlet qq
    :let qq : Maybe Integer ; qq = Just 3     

Currying: You can pass partially applied functions around:

    :let add: Int -> Int -> Int ; add x y = x + y
    :let ff = add 2
    ff 8
            
Functions with generic types:
Just make up a name beginning with lowercase and use it, can be a type:

    reapply: (a -> a) -> (a -> a)
    reapply f x = f (f x)            

Note there are even more advanced things it can be: see dependent types.
    
then `reapply (\x => x*x) 4` will be 256    

Now we know how `the` is defined!
    
    my_the: (ty : Type) -> ty -> ty
    my_the ty x = x
    
Dependent types in action! 
Now we see that all it does is enable type inference.

Constraints on generic types: a function that doubles any numeric type

    double2: Num ty => ty -> ty
    double2 x = x + x   

So `Num ty =>` is a type constraint on `ty`. Note also:

    :let kkk : Num ty => ty -> ty ; kkk l = l * l

In Idris, operations like + and * aren't primitive types - they are operators
on constrained types. When you define a numeric type, you have to
define the meaning of * and + for it! (Like implicits in Scala) Try `:t (+)`.
There is a Num Int, Num Double, etc. 
Note Integer is really BigInt, Int is fixed size
and `pow` has type `Num a => a -> Nat -> a`

    :doc Num
    
Similarly to `Num` there's `Eq` (supports ==, /=) and `Ord` 
( supports <, >, >=, <=).

Putting operators in brackets un-infixes them, e.g. (+).     
Can also curry them with e.g. (< 3), a function of type `Integer -> Bool.

You can have values with types but no definitions: these are 'holes'.
e.g. :let x : Int (and then presumably we define x later)
If we don't, `x < 3` becomes a hole of type Bool, but can't 
retroactively fill it in. 
"Can try and idea without fully defining the types and functions"

Anonymous functions using lambda: can have multiple arguments, with types:

    :let nnn = (\p : Int, q: Int => p + q)
    
`Let` blocks: Let you define variables. `where` lets you define functions.

    longer: String -> String -> Nat
    longer a b
        = let len1 = length a
              len2 = length b in
                if (len1 > len2) then len1 else len2
    
Note have to get the indentation right.

Invoke the REPL as `idris -p contrib` ; you'll then have the `contrib` package available.
Also put `opts = "-p contrib specdris"` in an .ipkg file to include packages.
In REPL can import with: e.g. `:module Test.Unit.Assertions`
Can define nice spec-style tests with Specdris - later: understand how this library works

To run something (e.g. main) that evaluates to an IO x:

    :exec main
    
(note there's also :x, which fails because FFI not included??)    


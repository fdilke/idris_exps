# REPL

## The `the` function - type inference
    :let t = the Nat 2
    
Define a variable `t` which is the natural number version of 2! 
You can then calculate `S t` as 3. There is no successor of int!

Can also use `cast` while telling which type to infer:

    the Integer (cast 9.9)
    
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
            
Functions with generic types:
Just make up a name beginning with lowercase and use it, will be assumed
to be a type:

    reapply: (a -> a) -> (a -> a)
    reapply f x = f (f x)            
    
then `reapply (\x => x*x) 4` will be 256    

Currying: You can pass partially applied functions around:

    :let add: Int -> Int -> Int ; add x y = x + y
    :let ff = add 2
    ff 8


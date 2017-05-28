## Experiments with Idris

# Done

- Create a repo
- Install Atom
- Install Idris (cabal update, cabal install idris. Takes ages) To /Users/Felix/Library/Haskell/bin
- Install plugin. Have to tell it location of executable

# To Do

- Notes on Atom
- Hello World program
- Calculate primes, or something!

# Notes on Atom

Ctl-Alt-R compile/check current file. Gives quite helpful messages in a nice font

# Notes on book

3 Type driven development. Loop is: Type, define, refine!
4 History: 2008 prototype, 2011 current implementation (since refined)
Types: a first class language construct. Can be sliced, diced, returned from functions, etc
Sophisticated type system. e.g. Can express: two lists have the same length.
5 Concept of code completion: For each function, do the following:

- write the input and output types
- define function body, guided by structure of input types
- refine, edit function / type definitions as necessary.

## Experiments with Idris

# Done

- Create a repo
- Install Atom
- Install Idris

# To Do

- Notes on Atom
- Hello World program
- Calculate primes, or something!

# Notes on Atom

hotkeys listed here:
https://github.com/idris-hackers/atom-language-idris

Ctl-Alt-R compile/check current file. Gives quite helpful messages in a nice font

# Helpful Idris stuff

A [tutorial](https://eb.host.cs.st-andrews.ac.uk/writings/idris-tutorial.pdf)

# Installing the Specdris testing library locally
    git clone https://github.com/pheymann/specdris.git
    cd specdris
    ./project --install

# Notes on book

3 Type driven development. Loop is: Type, define, refine!
4 History: 2008 prototype, 2011 current implementation (since refined)
Types: a first class language construct. Can be sliced, diced, returned from functions, etc
Sophisticated type system. e.g. Can express: two lists have the same length.
5 Concept of code completion: For each function, do the following:

- write the input and output types
- define function body, guided by structure of input types
- refine, edit function / type definitions as necessary.

# To build

    make
    
# Running the app
    make install
    ./idris_exps

    
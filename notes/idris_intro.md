<!-- pagenumber: true -->

# Learning Idris 

## a programming language which is like Haskell but more so

more precisely, a pure functional language 
that enables 'type driven development'

---

## Summary

- Why learn another language?

- What can I write in it?

- Why Idris?

- It's like Haskell but more so

- How do you learn a language?

- My First Idris Program

---

## Why learn yet another language?

- Inspired by "7 Languages in 7 Weeks"

- Learning a new language should not be hard

- It almost always makes you a better developer

- There are some interesting new languages out there

---

## What can I write in it? 

- Bewl is my DSL for topos theory, a math-heavy project 
which I already ported from Java / Clojure to Scala 

- Java's type system became too limiting

- Clojure's macros were great but I missed the strong typing

- Scala was a perfect fit.

- But, I use pretty much every inch of the playing surface
(fancy features of the language)

- What else might be possible?

---

## Why Idris?

- I considered Haskell, but Idris was too tempting as a
cutting-edge extension

- It has dependent types (very useful in Scala)

- Types are first class citizens. You can have functions returning
types, and 'type providers' (as in Microsoft's F#) 

- "Type driven development" sounds fun

- Also Idris has a proof checker built in, which even supports
topos logic.

---

## Like Haskell but more so

- Uncompromisingly functional

- You have to know all about metamonoidal
preprofunctors (only not really)

- There are "plumbing" operators like <>, |+|, >>= which it's
best not to pronounce at all

- Layout is like Python - non-free-form,
indentation is significant

- Keeps punctuation to a minimum.
Code can be lean and expressive (even cryptic)

---

## Like Haskell but more so (2)

- Not very mainstream

- Idris is the work of 1 person, Edwin Brady, a
lecturer in Comp.Sci at St Andrews U 

- He's not even working on it full time

- The documentation, tools and libraries are... 
not bad, considering

- Maybe not first choice for production systems

---

## Like Haskell but more so (3)

- Can you actually write Idris programs that do anything?

- Yes. Edwin Brady wrote a Space Invaders game in Idris

- It uses "Effects" (to do stateful things in a functionally 
pure way) and a 3rd party graphics library

- It took me most of a weekend to get this to build

---

## Like Haskell but more so (4)

- As a side benefit, I'm going to end up
sort-of learning Haskell

- The syntax and libraries are very similar

- Already, the 'Scala / Cats' book suddenly makes
sense

- Cats is a way to do Haskell/Idris stuff in Scala

---

## How do you learn a language?

- For Scala, I test-drove my exploration of
language features

- The result: github.com/fdilke/scala-exp which 
is at least a body of code to cut and paste from

- For Idris, this is daunting

- Brady's book "Type Driven Development with Idris" helps

- Also there is http://exercism.io (tutorials for many
programming languages) which shows how to set up a project 

---

## My First Idris Program

- Let's find all 3x3 acrostics

N | O | T
------- | -------- | --------
T | O | O
B | A | D

- a square of nine letters,
only with each row and column a word


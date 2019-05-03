# from Brady paper https://www.idris-lang.org/drafts/sms.pdf

An effect is described by an algebraic data type which gives the ops
supported by that effect, and parameterised by a resource type.

Limitations of effects:

- Concrete resource type is defined by *effect signature* rather than
implementation
- no convenient way to create new resources
- can't implement handlers for effects in terms of effects

How ST overcomes these: The type ST lets you describe pre and post 
conditions of a  "stateful function" which creates / destroys resources

Paper describes how via proof automation, Idris can show the state is
managed correctly as enforced by the type system.

Also can recast existing stateful APIs in terms of ST. 
One goal is to keep the DSL simple, enabling correctness without
cost in terms of complexity / cognitive load.

so: readable types, clear error messages : types
direct programmer to a working implementation.

Enable both horizontal and vertical composition of state machines.

Note he uses *indexed monads* - pre and post conditions aka Hoare triples

# about Control.ST (from the tutorial)

This is supposed to supersede effects (what does that imply for cats.effects?)
http://docs.idris-lang.org/en/latest/st/introduction.html 

FP: guarantee correct execution via type safety

but many components rely on state machines (TCP/IP, event driven apps,
regular expressions)
Many fundamental resources (files, net sockets) are managed this way
EG Can only send a msg to a socket once it is connected.
Can only close a socket once it's open.
ATM can only dispense cash after you've inserted a card and validated the PIN.

Control.ST is in *contrib*, based on ideas in Ch 13-14 of Brady's book. 

ST: lets you write apps with "multiple state transition systems".
Composition works 2 ways:

- can use several independently implemented ST systems at once
- can build new ST systems on top of existing ones

EG a data store requiring a login before you can do anything. 
There could be 2 states: LoggedOut, LoggedIn

so we have to codify: the idea of a system having a state, the state changing??
given we like objects to be immutable ... ? 
and you can "login" (with appropriate permissions) to get from
LoggedOut to LoggedIn

task for ST is to somehow provide an FP-style framework supporting this

# outline of tutorial

- describe how to manipulate states
- introduce a data type *STrans* for use in stateful functions
- use ST to describe top level state transitions.
- representing state machines in types
- defining interfaces for stateful systems
- using multiple state machines at once
- implementing high level ST sys in terms of low level ones
- a stateful API for POSIX network sockets

# intro: working with state

Control.ST enables programs to:

- do CRUD ops on state 
- track state changes in a function's type
 
based on concept of *resources* (modelled as mutable variables)
and a dependent type STrans (pronounce: state transition?)
which tracks how these resources change when a function runs: 

    STrans : (m: Type -> Type) ->
            (resultType : Type) ->
            (in_res : Resources) ->
            (out_res : resultType -> Resources) ->
            Type
            
I'm sure this was arrived at after long and hard thought.            

            
 

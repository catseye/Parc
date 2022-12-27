Parc
====

Parser combinator libraries are easy to write.  That's why GitHub is full of them.

I wanted to write a particularly simple one, both to expose its structure,
and to have something to experiment with.

### `Parc.hs`

The basic library is [`Parc.hs`](Parc.hs), about 35 lines long (including
type declarations and blank lines).
Some code that uses it can be found in [`ParcDemo.hs`](ParcDemo.hs).

But `Parc.hs` is so simple that you can only build a recognizer with it.
Generally, you want to do more with the input string than say whether it
is or is not in the language, yes?  So, there are more extended
versions here too.

### `ParcSt.hs`

An extension that adds state to the parser, making it a _stateful parser_,
is [`ParcSt.hs`](ParcSt.hs).
Some code that uses it can be found in [`ParcStDemo.hs`](ParcStDemo.hs).

This lets you write an actual parser, with an actual output value.

But even so, the facility it provides for state management is rather crude.
The type of the state variable is polymorphic, so the programmer can
choose any type they like for it.  But every parser combinator assumes
the state it will take as input is the same type as the state it will
produce on output.  In a strictly typed language, that can be a bit
limiting.  Ideally, we want to write parsers that parse different types of
things, then tie them together into bigger, composite parsers.

(This isn't a problem in a dynamically typed language, but in such
languages you have a different problem -- namely, the possibility of
a type mismatch somewhere in the composite parser which will only become
apparent at runtime.)

### `ParcSt2St.hs`

So we have a very small modification called [`ParcSt2St.hs`](ParcSt2St.hs).
In this, the `Parser` type is polymorphic on two types, one for input
and one for output.

Some code that uses this can be found in [`ParcSt2StDemo.hs`](ParcSt2StDemo.hs).
In fact, it is virtually a drop-in replacement for `ParcSt.hs`, as the type
signature is simply more general.

It does illuminate the types of the combinators somewhat though; `seq` has a
type that corresponds to transitivity, while `many` requires that the output
type is the same as the input type, which makes sense if you think of it as
a loop that may occur any number of times -- only an output that can be fed
back into the input would make sense there.

### `ParcMerge.hs`

To allow finer manipulation of the parsing state, we extend `ParcSt2St.hs`
with an extra combinator.  We can't build this combinator out of existing
combinators; it needs to access the parse state directly.  Also, its
definition turns out to be somewhat more complicated.  So, this is where
we start leaving "fits on a page" territory

The [`ParcMerge.hs`](ParcMerge.hs) module extends `ParcSt2St.hs` with a
combinator called `merge`.  `merge` takes a parser P and a function F which
takes two state values and returns a third state value as input; it
produces a new parser as its output.  This new parser applies P, then
produces a new state by combining the state before P, and the state produced
by P, using F.

[`ParcMergeDemo.hs`](ParcMergeDemo.hs) demonstrates how this `merge`
combinator can be used to apply arithmetic operators like `+` and `*`
when parsing an arithmetic expression.

### `ParcAssert.hs`

With what we have so far, if we merely accumulate state as we parse,
we can parse only context-free languages.

But if we enable the parser to succeed or fail based on some predicate
applied to the parsing state, we can parse context-sensitive languages.

(Actually, if we don't restrict ourselves to sufficiently simple
predicates, we can parse languages quite beyond the context-sensitive
range.  For example, we could use a predicate which checks if the
string passed to it is a valid sentence in Presburger arithmetic.
Formulating a set of parser combinators which actually (and provably)
is limited to parsing context-sensitive languages seems like a hard
(maybe open) problem.)

[`ParcAssertDemo.hs`](ParcAssertDemo.hs) uses `ParcSt2St` and adds a
combinator called `assert` that takes such a predicate on the parsing
state, and produces a parser which succeeds only when that predicate
is true on the current parsing state, failing otherwise.

The demo module gives an example of a parser for a classic
context-free language: strings of the form `a`^_n_ `b`^_n_ `c`^_n_.

### ... and more?

With luck, there will be further experiments added here over time.

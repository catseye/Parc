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

(Name provisional.)  TODO.

### ... and more?

With luck, there will be further experiments added here over time.

Parc
====

Parser combinator libraries are easy to write.  That's why GitHub is full of them.

I wanted to write a particularly simple one, both to expose its structure,
and to have something to experiment with.

The basic library is [`Parc.hs`](Parc.hs), about 35 lines long (including
type declarations and blank lines).
Some code that uses it can be found in [`ParcDemo.hs`](ParcDemo.hs).

But `Parc.hs` is so simple that you can only build a recognizer with it.
Generally, you want to do more with the input string than say whether it
is or is not in the language, yes?  So, there are more extended
versions here too.

An extension that adds user-defined state is [`ParcSt.hs`](ParcSt.hs).
Some code that uses it can be found in [`ParcStDemo.hs`](ParcStDemo.hs).

This lets you write an actual parser, with an actual output value.
But even so, the facility it provides for state management is quite crude.

With luck, there will be further experiments added here over time.

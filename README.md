# Wordcount.hs

This port of the [UNIX wc](https://en.wikipedia.org/wiki/Wc_%28Unix%29) utility comes via [*The Essence of the Iterator Pattern*](https://www.cs.ox.ac.uk/jeremy.gibbons/publications/iterator.pdf) by Jeremy Gibbons and Bruno Oliveira.

The module includes two implementations for enumerating monoidal sums for lines, words, and characters separately: one in monadic style and one in applicative. Both use the `State` monad to encapsulate a boolean value when counting words, but the monadic version maps over the `Writer` monad for characters and lines whereas the applicative version defines a constant function for the same purpose and then applies `traverse` to all three.

The applicative version allows the results to be composed more flexibly, allowing them to be ran in parallel and/or with the logarithmic time complexity characteristic of iteration in imperative languages. This most notably led to the [Applicative Monad Proposal](https://wiki.haskell.org/Functor-Applicative-Monad_Proposal) in Haskell 2014 that was used to optimize GHC by eliminating the need for list fusion when sequencing monads.

It runs as a command line tool like so:

```
> ./Wordcount "This is a test, this is only a test."
0
9
36

> cat haiku.txt | ./Wordcount
3
14
84
```
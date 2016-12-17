#Wordcount.hs

This faithful port of the [UNIX wc](https://en.wikipedia.org/wiki/Wc_%28Unix%29) utility comes via the paper [*The Essence of the Iterator Pattern*](https://www.cs.ox.ac.uk/jeremy.gibbons/publications/iterator.pdf) by Jeremy Gibbons and Bruno C. d. S. Oliveira.

Although this simple verison uses `Writer` and `State` monads and reporting monoidal sums for lines, words, and characters separately; the paper goes on to discuss versions that compose the results, both sequentially, and (most notably) in parallel using the `traverse` operation on applicative functors to achieve logarithmic time. This most notably led to the [Applicative Monad Proposal](https://wiki.haskell.org/Functor-Applicative-Monad_Proposal) in Haskell 2014 that was used to optimize GHC by eliminating the need for list fusion when sequencing monads.

This runs as a command line tool like so:

```
> ./Wordcount "This is a test, this is only a test"
1
9
36
```
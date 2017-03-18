module Main where

import Prelude hiding (lcm)
import System.IO
import System.Environment
import Control.Monad.State
import Control.Monad.Writer hiding (Product)
import Control.Applicative
import Data.Char
import Data.Functor.Compose
import Data.Functor.Product

test :: Bool -> Int
test b = if b then 1 else 0

----------------------------------------------------------------

-- Monadic version

ccmBody :: Char -> Writer (Sum Int) ()
ccmBody c = tell (Sum 1) >> return ()

ccm :: String -> Writer (Sum Int) ()
ccm = mapM_ ccmBody

cc :: String -> Int
cc c = getSum $ execWriter (ccm c)

lcmBody :: Char -> Writer (Sum Int) ()
lcmBody c = tell (Sum $ test (c == '\n')) >> return ()

lcm :: String -> Writer (Sum Int) ()
lcm = mapM_ lcmBody

lc :: String -> Int
lc c = getSum $ execWriter (lcm c) 

wcmBody :: Char -> State (Int, Bool) ()
wcmBody c = let s = not (isSpace c) in do
              (n,w) <- get
              put (n + (test(not w && s)), s)
              return ()

wcm :: String -> State (Int, Bool) ()
wcm = mapM_ wcmBody

wc :: String -> Int
wc c = fst $ execState (wcm c) (0, False)

main :: IO ()
main = do
  contents <- getContents
  args <- getArgs
  let text = case args of 
               [] -> contents
               _  -> args !! 0
  mapM_ (putStrLn . ($ text)) $ [show . lc, show . wc, show . cc]

----------------------------------------------------------------

-- Applicative Version

prod :: (Functor m, Functor n) => (a -> m b) -> (a -> n b) -> (a -> Product m n b)
prod f g x = Pair (f x) (g x)

type Count = Const (Sum Int)
count :: Int -> Count b
count n = Const (Sum n)

cciBody :: Char -> Count a
cciBody _ = count 1

cci :: String -> Count [a]
cci = traverse cciBody

lciBody :: Char -> Count a
lciBody c = count $ test (c == '\n')

lci :: String -> Count [a]
lci = traverse lciBody

wciBody :: Char -> Compose (State Bool) Count a
wciBody c = Compose $ let s = not (isSpace c) in do
                        w <- get
                        put s
                        return (count (test(not w && s)))

wci :: String -> Compose (State Bool) Count [a]
wci = traverse wciBody

runWci :: String -> Int
runWci s = fst $ execState (wcm s) (0, False)

cclwi :: String -> Product (Product Count Count) (Compose (State Bool) Count) [a]
cclwi = traverse (cciBody `prod` lciBody `prod` wciBody)

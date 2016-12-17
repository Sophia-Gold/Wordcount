module Main where

import System.IO
import System.Environment
import Control.Monad.State
import Control.Monad.Writer
import Data.Monoid
import Data.Char

test :: Bool -> Int
test b = if b then 1 else 0

ccmBody :: Char -> Writer (Sum Int) Char
ccmBody c = tell (Sum 1) >> return c

ccm :: String -> Writer (Sum Int) String
ccm = mapM ccmBody

cc :: String -> Int
cc c = getSum $ execWriter (ccm c)

lcmBody :: Char -> Writer (Sum Int) Char
lcmBody c = tell (Sum $ test (c == '\n')) >> return c

lcm' :: String -> Writer (Sum Int) String
lcm' = mapM lcmBody

lc :: String -> Int
lc c = getSum $ execWriter (lcm' c) 

wcmBody :: Char -> State (Int, Bool) Char
wcmBody c = let s = not (isSpace c) in do
              (n,w) <- get
              put (n + (test(not w && s)), s)
              return c

wcm :: String -> State (Int, Bool) String
wcm = mapM wcmBody

wc :: String -> Int
wc c = fst $ execState (wcm c) (0, False)

main :: IO ()
main = do
  contents <- getContents
  print $ lc contents
  print $ wc contents
  print $ cc contents

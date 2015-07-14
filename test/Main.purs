-- | This example requires `purescript-node-readline` to be installed.

module Test.Main where

import Prelude

import Control.Monad.Eff.Console

import Signal
import Signal.Loop

import Node.ReadLine

main = do
  interface <- createInterface noCompletion

  let makePrompt :: String -> Emitter _ String
      makePrompt s k = void do
        log $ "You typed: " ++ s
        setPrompt "> " 2 interface
        setLineHandler k interface
        prompt interface
 
  -- The loop reads the most recently entered string from the "future" signal
  -- and uses the makePrompt function to display it.
  loop "" \future -> makePrompt <$> future

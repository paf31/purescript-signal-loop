module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Signal.Channel (CHANNEL)
import Signal.Loop (Emitter, runLoop)

main :: Eff (console :: CONSOLE, channel :: CHANNEL) Unit
main = void do
  let view :: Int -> Emitter (console :: CONSOLE, channel :: CHANNEL) Int
      view n emit = void do
        log $ "Received: " <> show n
        when (n < 10) $ emit (n + 1)

  -- The loop reads the most recent value from the "future" signal
  -- and uses the view function to display it and simulate the next event.
  runLoop 0 \future -> map view future

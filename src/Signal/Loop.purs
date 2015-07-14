-- | This module defines a higher-level abstraction on top of channels,
-- | called _signal loops_. A signal loop is a function which produces a
-- | signal, given partial information about its own future values.
module Signal.Loop where

import Prelude

import Control.Monad.Eff

import Signal
import Signal.Channel

-- | An `Emitter` is a function which renders a state and emits new values 
-- | onto a `Channel`. For example:
-- |
-- | - a function which renders a HTML document and emits generated DOM events.
-- | - a function which prints some text and emits console input.
type Emitter eff a = Channel a -> Eff eff Unit

-- | A loop is a function from a future input signal to an `Emitter` of values
-- | of the same input type.
type Loop eff a = Signal a -> Signal (Emitter (chan :: Chan | eff) a)

-- | Run a loop, given an initial input.
runLoop :: forall eff a. a -> Loop eff a -> Eff (chan :: Chan | eff) Unit
runLoop a f = do
  c <- channel a 
  let emitter = f (subscribe c)
  runSignal (($ c) <$> emitter)

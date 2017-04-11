-- | This module defines a higher-level abstraction on top of channels,
-- | called _signal loops_. A signal loop is a function which produces a
-- | signal, given partial information about its own future values.
module Signal.Loop where

import Prelude
import Control.Monad.Eff (Eff)
import Signal (Signal, runSignal)
import Signal.Channel (CHANNEL, channel, send, subscribe)

-- | An `Emitter` is a function which renders a state and emits new values
-- | onto a `Channel`. For example:
-- |
-- | - a function which renders a HTML document and emits generated DOM events.
-- | - a function which prints some text and emits console input.
type Emitter eff a = (a -> Eff eff Unit) -> Eff eff Unit

-- | A loop is a function from a future input signal to an `Emitter` of values
-- | of the same input type.
type Loop eff a = Signal a -> Signal (Emitter eff a)

-- | Run a loop, given an initial value.
-- | The effects of the `Emitter`s are run inside of Eff. The initial value and
-- | the emitted values are provided by the Signal in this Eff's return value.
-- | If you aren't using these values outside of your `Emitter`s then you don’t
-- | need to use this Signal.
runLoop
  :: forall eff a
   . a
  -> Loop (channel :: CHANNEL | eff) a
  -> Eff (channel :: CHANNEL | eff) (Signal a)
runLoop a f = do
  c <- channel a
  let s = subscribe c
  runSignal (map (_ $ send c) (f s))
  pure s

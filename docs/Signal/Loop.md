## Module Signal.Loop

This module defines a higher-level abstraction on top of channels,
called _signal loops_. A signal loop is a function which produces a
signal, given partial information about its own future values.

#### `Emitter`

``` purescript
type Emitter eff a = Channel a -> Eff eff Unit
```

An `Emitter` is a function which renders a state and emits new values 
onto a `Channel`. For example:

- a function which renders a HTML document and emits generated DOM events.
- a function which prints some text and emits console input.

#### `Loop`

``` purescript
type Loop eff a = Signal a -> Signal (Emitter (chan :: Chan | eff) a)
```

A loop is a function from a future input signal to an `Emitter` of values
of the same input type.

#### `runLoop`

``` purescript
runLoop :: forall eff a. a -> Loop eff a -> Eff (chan :: Chan | eff) Unit
```

Run a loop, given an initial input.



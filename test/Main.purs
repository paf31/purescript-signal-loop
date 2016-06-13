module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Exception (EXCEPTION)
import Node.ReadLine (READLINE, createConsoleInterface, noCompletion, setPrompt,
                      setLineHandler, prompt)
import Signal.Channel (CHANNEL)
import Signal.Loop (Emitter, runLoop)

main :: Eff ( readline  :: READLINE
            , console   :: CONSOLE
            , channel   :: CHANNEL
            , err       :: EXCEPTION
            ) Unit
main = void do
  interface <- createConsoleInterface noCompletion

  let makePrompt :: String -> Emitter ( readline  :: READLINE
                                      , console   :: CONSOLE
                                      , channel   :: CHANNEL
                                      , err       :: EXCEPTION
                                      ) String
      makePrompt s emit = void do
        log $ "You typed: " <> s
        setPrompt "> " 2 interface
        setLineHandler interface emit
        prompt interface

  -- The loop reads the most recently entered string from the "future" signal
  -- and uses the makePrompt function to display it.
  runLoop "" \future -> makePrompt <$> future

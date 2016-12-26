module Messages exposing (..)


import Model exposing (..)
import Time exposing (Time)


type Message =
    Tick Time |
    ActionMsg Action |
    Message String |
    SomethingElse


type Action =
    Move Location |
    Gather Resource |
    StartCombat Enemy


type CombatAction =
    Fight |
    Run



type alias Location = (Int, Int)

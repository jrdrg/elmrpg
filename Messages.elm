module Messages exposing (..)


import Model exposing (..)
import Time exposing (Time)


type Message =
    ActionMsg Action |
    SomethingElse


type Action =
    Tick Time |
    Move Location |
    Gather Resource |
    StartCombat Enemy |
    Enter


type CombatAction =
    Fight |
    Run



type alias Location = (Int, Int)

module Messages exposing (..)


import Types exposing (..)
import Time exposing (Time)


type Message =
    Tick Time |
    ChangeState GameState |
    ActionMsg Action |
    Message String |
    RandomEvent Int |
    CombatMsg CombatAction


type Action =
    BeginMove Location |
    Move Location |
    Gather Resource |
    StartCombat Enemy


type CombatAction =
    Fight |
    Run



type alias Location = (Int, Int)

module Messages exposing (..)


import Types exposing (..)
import Time exposing (Time)
import Combat.Messages
import Model exposing (GameState(..))


type Message =
    Tick Time |
    RestartGame |
    ChangeState GameState |
    ActionMsg Action |
    Message String |
    RandomEvent Int |
    CombatMsg Combat.Messages.Message


type Action =
    BeginMove Location |
    Move Location |
    Gather Resource |
    StartCombat Enemy



type alias Location = (Int, Int)

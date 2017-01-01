module RandomEvents exposing (..)

import Types exposing (GameState(..))
import Model exposing (Model)
import Messages exposing (Message(..))


randomEvent: Int -> Model -> (Model, Cmd Message)
randomEvent probability model =
    if probability < 50
    then
        { model |
               state = Action
        } ! [Cmd.none]
    else
        model ! [Cmd.none]

module RandomEvents exposing (..)

import Types exposing (GameState(..))
import Model exposing (Model)
import Messages exposing (Message(..))
import Combat.Model exposing (initializeNewCombat)


randomEvent: Int -> Model -> (Model, Cmd Message)
randomEvent probability model =
    if probability < 10
    then
        {
            model |
                state = Action
        } ! []
    else if probability < 60
         then
             {
                 model |
                     state = Battle,
                     combat = Just initializeNewCombat
             } ! []
    else
        model ! []

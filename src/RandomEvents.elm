module RandomEvents exposing (..)

import Model exposing (Model, GameState(..))
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
                     state = Battle (Just initializeNewCombat)
             } ! []
    else
        model ! []

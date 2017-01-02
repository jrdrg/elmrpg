module Update exposing (..)


import Types exposing (GameState(..))
import Model exposing (Model, setPlayerLocation, PlayerMovement(..), moveTo)
import Messages exposing (..)
import Animations.Update
import Map.Update
import Combat.Update


update: Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        Tick time ->
            Animations.Update.update msg model

        _ ->
            case model.state of
                Action ->
                    actionUpdate msg model

                Battle ->
                    Combat.Update.update msg model

                Map ->
                    Map.Update.update msg model

                _ ->
                    (model, Cmd.none)


actionUpdate: Message -> Model -> (Model, Cmd Message)
actionUpdate msg model =
    ({ model |
           state = Map
     }, Cmd.none)

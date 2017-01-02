module Update exposing (..)


import Types exposing (GameState(..))
import Model exposing (Model, createModel, setPlayerLocation, PlayerMovement(..), moveTo)
import Messages exposing (..)
import Animations.Update
import Map.Update
import Combat.Update
import GameOver


update: Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        Tick time ->
            Animations.Update.update msg model

        RestartGame ->
            createModel ! []

        _ ->
            case model.state of
                Action ->
                    actionUpdate msg model

                Battle ->
                    let
                        updater =
                            Combat.Update.update msg << GameOver.checkForGameOver
                    in
                        updater model

                Map ->
                    let
                        updater =
                            Map.Update.update msg << GameOver.checkForGameOver
                    in
                        updater model

                _ ->
                    (model, Cmd.none)


actionUpdate: Message -> Model -> (Model, Cmd Message)
actionUpdate msg model =
    ({ model |
           state = Map
     }, Cmd.none)

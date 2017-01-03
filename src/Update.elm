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
                    let
                        (newModel, cmd) = actionUpdate msg model
                    in
                        GameOver.checkForGameOver newModel ! [cmd]

                Battle ->
                    let
                        (newModel, cmd) = Combat.Update.update msg model
                    in
                        GameOver.checkForGameOver newModel ! [cmd]

                Map ->
                    let
                        (newModel, cmd) = Map.Update.update msg model
                    in
                        GameOver.checkForGameOver newModel ! [cmd]

                _ ->
                    (model, Cmd.none)


actionUpdate: Message -> Model -> (Model, Cmd Message)
actionUpdate msg model =
    ({ model |
           state = Map
     }, Cmd.none)

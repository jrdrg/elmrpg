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
            let (newModel, cmd) =
                case model.state of
                    Action ->
                        actionUpdate msg model

                    Battle enemies -> -- TODO pass this to Combat.Update
                        Combat.Update.update msg model

                    Map ->
                        Map.Update.update msg model

                    _ ->
                        (model, Cmd.none)
            in
                GameOver.checkForGameOver newModel ! [cmd]


actionUpdate: Message -> Model -> (Model, Cmd Message)
actionUpdate msg model =
    ({ model |
           state = Map
     }, Cmd.none)

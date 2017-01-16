module Update exposing (..)


import Model exposing
    (
     Model, GameState(..),
     createModel, setPlayerLocation, PlayerMovement(..), moveTo
    )
import Messages exposing (..)
import Animations.Update
import Map.Update
import Combat.Update
import Combat.Model exposing (initializeNewCombat)
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

                    Battle combat ->
                        Combat.Update.update msg model (Maybe.withDefault initializeNewCombat combat)

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

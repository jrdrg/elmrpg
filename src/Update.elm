module Update exposing (..)


import Random
import Types exposing (GameState(..))
import Model exposing (Model)
import Messages exposing (..)
import Grid exposing (isNeighbor)
import RandomEvents


update: Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        Tick time ->
            let
                updated = {model | currentTick = time}
            in
                (updated, Cmd.none)

        _ ->
            case model.state of
                Action ->
                    actionUpdate msg model
                Map ->
                    mapUpdate msg model
                _ ->
                    (model, Cmd.none)



actionUpdate: Message -> Model -> (Model, Cmd Message)
actionUpdate msg model =
    ({ model |
           state = Map
     }, Cmd.none)


mapUpdate: Message -> Model -> (Model, Cmd Message)
mapUpdate msg model =
    case msg of
        Message message ->
            let
                updated = {model | messages = List.take 10 (message :: model.messages)}
            in
                (updated, Cmd.none)

        RandomEvent probability ->
            RandomEvents.randomEvent probability model

        ActionMsg action ->
            case action of
                Move (x, y) ->
                    let
                        {player} = model
                        currentLocation = player.location
                        canMove = isNeighbor currentLocation { x = x, y = y }
                        updatedLocation = { currentLocation | x = x, y = y }
                        updatedPlayer = { player | location = updatedLocation }

                        (updated, message) =
                            if canMove
                            then
                                ({ model | player = updatedPlayer },
                                 "Moved to " ++ (toString x) ++ ", " ++ (toString y))
                            else
                                (model, "Cannot move there")

                        (newModel, _) = update (Message message) updated
                    in
                        if canMove
                        then
                            (newModel, Random.generate RandomEvent (Random.int 1 100))
                        else
                            (newModel, Cmd.none)

                _ ->
                    (model, Cmd.none)

        _ ->
            (model, Cmd.none)

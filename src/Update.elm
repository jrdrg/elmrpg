module Update exposing (..)


import Random
import Types exposing (GameState(..))
import Model exposing (Model, setPlayerLocation, PlayerMovement(..), moveTo)
import Messages exposing (..)
import Grid exposing (isNeighbor)
import RandomEvents
import Animations.Model
import Animations.Update
import Map.Utils exposing (hexCoords)


update: Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        Tick time ->
            Animations.Update.update msg model

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
            doAction action model

        _ ->
            model ! []


doAction: Action -> Model -> (Model, Cmd Message)
doAction action model =
    case action of
        BeginMove (x, y) ->
            let
                {player} = model

                startAnimation =
                    case model.animations.moving of
                        Just animation ->
                            Just animation
                        Nothing ->
                            case player.location of
                                CurrentLocation coords ->
                                    let
                                        canMove = isNeighbor coords { x = x, y = y }
                                    in
                                        if canMove
                                        then
                                            let
                                                startPos = hexCoords coords.x coords.y
                                                endPos = hexCoords x y
                                                toPoint = \pos -> (round pos.x, round pos.y)
                                            in
                                                Just <| Animations.Model.newCoordinateAnimation (toPoint startPos) (toPoint endPos) model.currentTick
                                        else
                                            Nothing
                                _ ->
                                    Nothing

                updatedAnimation =
                    \anim -> { anim | moving = startAnimation }

                updateLocation =
                    \player ->
                        case player.location of
                            CurrentLocation coords ->
                                let
                                    startPos = hexCoords coords.x coords.y
                                in
                                    { player | location = Moving { x = startPos.x, y = startPos.y } { x = x, y = y } }
                            _ ->
                                player

                (messageIfCannotMove, _) =
                    case startAnimation of
                        Nothing ->
                            update (Message "Cannot move there") model
                        _ ->
                            model ! []
            in
                -- start movement animation, fire off Move action when it's done
                {
                    messageIfCannotMove |
                        animations = updatedAnimation model.animations,
                        player =
                            case startAnimation of
                                Nothing ->
                                    model.player
                                _ ->
                                    updateLocation model.player
                } ! []

        Move (x, y) ->
            let
                {player} = model
                currentLocation = player.location
                updatedPlayer = moveTo player { x = x, y = y }

                (updated, message) =
                    ({ model | player = updatedPlayer },
                     "Moved to " ++ (toString x) ++ ", " ++ (toString y))

                (newModel, _) = update (Message message) updated
            in
                (newModel, Random.generate RandomEvent (Random.int 1 100))

        _ ->
            model ! []


locationToPoint: { x: Float, y: Float } -> Grid.Point {}
locationToPoint location =
    {
        x = round location.x,
        y = round location.y
    }

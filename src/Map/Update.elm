module Map.Update exposing (update)


import Random
import Grid
import Messages exposing (..)
import Model exposing (..)
import Animations.Model
import Map.Utils exposing (hexCoords)
import RandomEvents


update: Message -> Model -> (Model, Cmd Message)
update msg model =
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
        BeginMove location ->
            beginMove model location

        Move (x, y) ->
            let
                {player} = model
                processMove = moveTo { x = x, y = y } << subtractFood 1
                updatedPlayer = processMove player

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


beginMove: Model -> (Int, Int) -> (Model, Cmd Message)
beginMove model (x, y) =
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
                                canMove = Grid.isNeighbor coords { x = x, y = y }
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


subtractFood: Int -> Player -> Player
subtractFood amount player =
    let
        newFood = clamp 0 100 (player.food.current - amount)
    in
        {
            player |
                food =
                    {
                        current = newFood,
                        max = player.food.max
                    }
        }

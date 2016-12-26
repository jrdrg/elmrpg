module Update exposing (..)


import Model exposing (Model)
import Messages exposing (..)
import Grid exposing (isNeighbor)


update: Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        Tick time ->
            let
                updated = {model | currentTick = time}
            in
                (updated, Cmd.none)

        Message message ->
            let
                updated = {model | messages = List.take 10 (message :: model.messages)}
            in
                (updated, Cmd.none)

        ActionMsg action ->
            case action of
                Move (x, y) ->
                    let
                        {player} = model
                        currentLocation = player.location
                        canMove = isNeighbor currentLocation { x = x, y = y }
                        updatedLocation = { currentLocation | x = x, y = y }
                        updatedPlayer = { player | location = updatedLocation }

                        updated =
                            if canMove then
                                {
                                    model |
                                    player = updatedPlayer
                                }
                            else
                                model

                        message =
                            if canMove then
                                "Moved to " ++ (toString x) ++ ", " ++ (toString y)
                            else
                                "Cannot move there"
                    in
                        update (Message message) updated

                _ ->
                    (model, Cmd.none)

        _ ->
            (model, Cmd.none)

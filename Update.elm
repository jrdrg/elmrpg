module Update exposing (..)


import Model exposing (Model)
import Messages exposing (..)


update: Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        ActionMsg action ->
            case action of
                Tick time ->
                    let
                        updated = {model | currentTick = 1}
                    in
                        (updated, Cmd.none)

                Move (x, y) ->
                    let
                        setLocation = \location -> { location | x = x, y = y }
                        updatePlayerLocation = \player -> { player | location = setLocation player.location }
                        updated =
                            {model | player = updatePlayerLocation model.player}
                    in
                        Debug.log "Test"
                        (updated, Cmd.none)

                _ ->
                    (model, Cmd.none)

        _ ->
            (model, Cmd.none)

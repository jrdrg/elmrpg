module Animations.Update exposing (update)


import Animations.Model
import Messages exposing (..)
import Model exposing (..)
import Task


update: Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        Tick time ->
            let
                location = model.player.location
                (newLocation, isMovementComplete) =
                    case location of
                        Moving pixelLocation toCoords ->
                            case model.animations.moving of
                                Just animation ->
                                    let
                                        newLoc = Animations.Model.animateCoordinates animation time
                                        isComplete = Animations.Model.isComplete animation time
                                    in
                                        (Moving newLoc toCoords, isComplete)
                                Nothing ->
                                    (CurrentLocation toCoords, True)

                        CurrentLocation coords ->
                            (CurrentLocation coords, True)

            in
                case newLocation of
                    Moving pixelLocation toCoords ->
                        let
                            (movedPlayer, cmd) =
                                if isMovementComplete
                                then
                                    model ! [Task.perform ActionMsg (Task.succeed (Move (toCoords.x, toCoords.y)))]
                                else
                                    {
                                        model |
                                            player = setPlayerLocation model.player pixelLocation
                                    } ! []
                        in
                            {
                                movedPlayer |
                                    currentTick = time,
                                    animations =
                                        if isMovementComplete
                                        then
                                            Animations.Model.removeMovementAnimation model.animations
                                        else
                                            model.animations
                            } ! [cmd]

                    CurrentLocation coords ->
                        {
                            model |
                                currentTick = time
                        } ! []

        _ ->
            model ! []

module Animations.Model exposing
    (
     Animations, init,
     newCoordinateAnimation, animateCoordinates, isComplete,
     removeMovementAnimation
    )


import Time exposing (Time)
import Animation exposing (from, to, duration)
import Messages exposing (..)


type alias Animations =
    {
        moving: Maybe CoordinateAnimation
    }


type alias CoordinateAnimation =
    {
        x: Animation.Animation,
        y: Animation.Animation
    }


init: Animations
init =
    {
        moving = Nothing
    }


newCoordinateAnimation: (Int, Int) -> (Int, Int) -> Time -> CoordinateAnimation
newCoordinateAnimation (startX, startY) (endX, endY) time =
    {
        x = Animation.animation time |> from (toFloat startX) |> to (toFloat endX) |> duration (Time.second * 0.5),
        y = Animation.animation time |> from (toFloat startY) |> to (toFloat endY) |> duration (Time.second * 0.5)
    }


removeMovementAnimation: Animations -> Animations
removeMovementAnimation model =
    { model | moving = Nothing }


animateCoordinates: CoordinateAnimation -> Time ->  { x: Float, y: Float }
animateCoordinates coords time =
    {
        x = Animation.animate time coords.x,
        y = Animation.animate time coords.y
    }


isComplete: CoordinateAnimation -> Time -> Bool
isComplete coords time =
    Animation.timeRemaining time coords.x == 0
    &&
    Animation.timeRemaining time coords.y == 0

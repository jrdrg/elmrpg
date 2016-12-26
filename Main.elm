module Main exposing (..)

import Html
import Time
import AnimationFrame
import Update exposing (update)
import Model exposing (Model, createModel)
import View exposing (view)
import Messages exposing (..)


main: Program Never Model Message
main =
  Html.program
      {
          init = init,
          subscriptions = subscriptions,
          update = update,
          view = view
      }


init: (Model, Cmd Message)
init =
    (createModel, Cmd.none)


subscriptions: Model -> Sub Message
subscriptions model =
    Sub.batch [
         AnimationFrame.times Tick
        ]

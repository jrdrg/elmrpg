module Main exposing (..)

import Html
import Update exposing (update)
import Model exposing (Model, createModel)
import View exposing (view)
import Messages exposing (Message)


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
    Sub.batch []

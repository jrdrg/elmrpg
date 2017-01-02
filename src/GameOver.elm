module GameOver exposing (view, checkForGameOver)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Types exposing (..)


view: Model -> Html Message
view model =
    let
        gameOverMessage =
            case model.state of
                GameOver reason ->
                    reason
                _ ->
                    "Something bad happened!"
    in
    div [class "section", style [("textAlign", "center")]]
        [h1 [class "title"] [text "Game Over"]
        ,div []
             [text gameOverMessage]
        ,div []
             [a   [onClick RestartGame
                  ,class "button is-outlined"]
                  [text "Restart?"]
             ]
        ]


checkForGameOver: Model -> Model
checkForGameOver model =
    let
        {player} = model
        outOfFood = player.food.current <= 0
        gotKilled = player.hp.current <= 0
    in
        if outOfFood
        then
            {
                model |
                    state = GameOver "You starved."
            }
        else if gotKilled
             then
                 {
                     model |
                         state = GameOver "You got killed."
                 }
             else
                 model

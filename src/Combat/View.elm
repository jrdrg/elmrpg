module Combat.View exposing (view)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (..)
import Model exposing (..)
import Messages exposing (..)
import Combat.Messages exposing (Message(..))
import Combat.Model exposing (Combat, initializeNewCombat)


view: Model -> Html Messages.Message
view model =
    case model.state of
        Battle ->
            let
                combat =
                    case model.combat of
                        Just combat ->
                            combat
                        _ ->
                            initializeNewCombat

            in
                renderModal model combat
        _ ->
            text ""


renderModal: Model -> Combat -> Html Messages.Message
renderModal model combat =
    let
        action =
            \desc icon ->
                div [class "actionLink"]
                    [a   [class "button is-dark"
                         ,style [("width", "100%"), ("justifyContent", "flex-start")]
                         ,onClick (CombatMsg (PlayerAttack 0))]
                         [i [class ("game-icon " ++ icon)] []
                         ,text desc]]
    in
        div [class "modal is-active"]
            [div [class "modal-background"] []
            ,div [class "modal-content"]
                 [div [class "notification bgcolor"
                      ,style [("height", "400px")]
                      ]
                      [h1 [class "title"] [text "Fight!"]
                      ,div [class "enemies"]
                           (List.map renderEnemy combat.enemies)
                      ,action "Attack" "game-icon game-icon-broadsword"]]
            ]


renderEnemy: Enemy -> Html Messages.Message
renderEnemy enemy =
    let
            -- ,style [("backgroundPosition", position)]
        (x, y) = enemy.imageCoords
        imagePosition =
            (toString x) ++ "px " ++ (toString y) ++ "px"
    in
        div [class "enemyDisplay"]
            [div [] [text enemy.name]
            ,div [class "hexImg"]
                 [div [class (enemy.image ++ " tileImage pixelImage")
                      ,style [("backgroundPosition", imagePosition)]]
                      []]
            ,div [] [text <| (toString enemy.hp.current) ++ "/" ++ (toString enemy.hp.max)]
            ]

module View exposing (view)


import Html exposing (..)
import Html.Attributes exposing (style, class)
import Html.Events exposing (..)
import Types exposing (GameState(..))
import Model exposing (..)
import Messages exposing (Message(..))
import Map.Utils exposing (cellSize, hexCoords, positionStyle)
import Map.View
import Combat.View
import GameOver


view: Model -> Html Message
view model =
    let
        modal =
            if model.state == Action
            then
                renderActionModal model
            else
                text ""
        currentView =
            case model.state of
                GameOver message ->
                    GameOver.view model
                _ ->
                    div []
                        [mainSection model
                        ,modal
                        ,Combat.View.view model]
    in
        div [class "container_"]
            [topBar model
            ,currentView
            ]



renderActionModal: Model -> Html Message
renderActionModal model =
    let
        modalClass =
            if model.state == Action
            then "modal is-active"
            else "modal"
        action =
            \desc icon ->
                div [class "actionLink"]
                    [a   [class "button is-dark"
                         ,style [("width", "100%"), ("justifyContent", "flex-start")]
                         ,onClick (ChangeState Map)]
                         [i [class ("game-icon " ++ icon)] []
                         ,text desc]]
    in
        div [class modalClass]
            [div [class "modal-background"] []
            ,div [class "modal-content"]
                 [div [class "notification bgcolor"
                      ,style [("height", "400px")]
                      ]
                      [text "a random event happened!"
                      ,action "Choice 1" ""
                      ,action "Choice 2" ""
                      ,action "Choice 3" ""]]
            ]


topBar: Model -> Html Message
topBar model =
    nav [class "nav has-shadow"]
        [div [class "nav-left"]
             [a [class "nav-item"] [text "This game has no title yet"]]
        ,div [class "nav-right"]
             [a [class "nav-item"] [text "Map"]
             ,a [class "nav-item"] [text "Inventory"]
             ,a [class "nav-item"] [text "Status"]]
        ]


mainSection: Model -> Html Message
mainSection model =
    div [class "section"]
        [div [class "container"]
             [div [class "tile is-ancestor"]
                  [div [class "tile is-vertical"]
                       [middleSection model
                       ,bottomSection model]
                  ]
             ]
        ]


middleSection: Model -> Html Message
middleSection model =
    div [class "tile"]
        [drawPlayerHp model.player
        ,section_ "is-6" "Map" <| renderMap model
        ,section_ "is-3" "Stats" <| playerStats model.player
        ]


bottomSection: Model -> Html Message
bottomSection model =
    div [class "tile"]
        [--section "Actions" <| actions model
        --,
            section "Messages" <| messages model.messages
        ]


drawPlayerHp: Player -> Html Message
drawPlayerHp player =
    let
        header = \content -> span [class "header"] [text content]
        kv = \key value ->
             div []
                 [div [class "infoRowHeader"] [text key]
                 ,div [style [("marginBottom", "5px")]] [value]]
        info =
            div [class "character"]
                [kv "HP" (progressBar (255, 0, 0) player.hp.current player.hp.max)
                ,kv "MP" (progressBar (0, 100, 255) player.mp.current player.mp.max)
                ,kv "Food" (progressBar (0, 200, 0) player.food.current player.food.max)]
    in
        section "Character" <| info


renderMap: Model -> Html Message
renderMap model =
    let
        grid = model.map.grid
        {width, height} = model.map.size
        {x, y} =
            case model.player.location of
                Moving pixelLocation toCoords ->
                    toCoords
                CurrentLocation coords ->
                    coords
    in
        div [class "mapWrapper"]
            [div [class "mapContainer map3d_"]
                 [Map.View.view model.map (toFloat x, toFloat y)
                 ,renderPlayer model.player
                 ]
            ]


playerStats: Player -> Html Message
playerStats player =
    let
        header = \content -> span [class "header"] [text content]
        kv = \key value ->
             tr []
                 [td [class "infoRowHeader"] [text key]
                 ,td [] [text value]]
        x = 1
    in
        div [class "tile is-child playerInfo"]
            [div []
                 [table [class "infoRow"]
                        [kv "str" (toString player.str)
                        ,kv "dex" (toString player.dex)
                        ,kv "int" (toString player.int)
                        ,kv "end" (toString player.end)
                        ,kv "agi" (toString player.agi)
                        ]]
            ]


actions: Model -> Html Message
actions model =
    let
        player = model.player
        action =
            \desc icon ->
                div [class "actionLink"]
                    [a   [class "button is-dark", style [("width", "120px"), ("justifyContent", "flex-start")]]
                         [i [class ("game-icon " ++ icon)] []
                         ,text desc]]
    in
        div [class "actions"]
            [text "stuff"
            ,div [style [("width", "150px")]] [text <| toString model.currentTick]
            ,action " Fight" "game-icon-crossed-swords"
            ,action " Go hunting" "game-icon-hunting-horn"
            ,action " Mine rocks" "game-icon-minerals"
            ,action " Eat" "game-icon-meat"
            ]


messages: List String -> Html Message
messages messages =
    let
        renderMessage =
            \message ->
                div []
                    [text message]
    in
        div [class "messages"]
            (messages |> List.map renderMessage)


-- utility functions

renderPlayer: Player -> Html Message
renderPlayer player =
    let
        pixelLocation =
            case player.location of
                Moving location toCoords ->
                    location
                CurrentLocation coords ->
                    hexCoords coords.x coords.y
        size = cellSize
        actualWidth = 32
        actualHeight = 32
        offsetX = pixelLocation.x + (size.width - actualWidth) / 2
        offsetY = pixelLocation.y + (size.height - actualHeight) / 2
    in
        div [class "player"
            ,style <| positionStyle actualWidth actualHeight offsetX offsetY
            ]
            [div [class "playerImg pixelImage"] []]


section: String -> Html Message -> Html Message
section = section_ ""

section_: String -> String -> Html Message -> Html Message
section_ additionalClasses header content =
    div [class <| "tile is-parent " ++ additionalClasses]
        [div [class "tile is-child notification boxSection"]
             [div [class "_section content"]
                  [h1  [class "_sectionHeader"]
                       [text header]
                  ,p   [class "_sectionContent"]
                       [content]]
             ]
        ]


progressBar: (Int, Int, Int) -> Int -> Int -> Html Message
progressBar color current max =
    let
        height = (10 |> toString) ++ "px"
        pct = ((toFloat current) / (toFloat max)) * 100
        barWidth = (pct |> toString) ++ "%"
        (r, g, b) = color
        toRgba = \r_ g_ b_ -> "rgba(" ++ (toString r_) ++ "," ++ (toString g_) ++ "," ++ (toString b_) ++ ", 1)"
    in
        div [style [("width", "150px")
                   ,("backgroundColor", toRgba (r // 2) (g // 2) (b // 2))
                   ,("display", "flex")
                   ,("border", "1px solid #666")
                   ,("height", height)]]
            [div [style [("backgroundColor", toRgba r g b)
                        ,("width", barWidth)]]
                 []]

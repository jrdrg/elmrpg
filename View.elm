module View exposing (view)


import Html exposing (..)
import Html.Attributes exposing (style, class)
import Model exposing (..)
import Messages exposing (Message)
import Grid exposing (Grid)
import Map.Utils exposing (cellSize, hexCoords, positionStyle)
import Map.View exposing (view)


view: Model -> Html Message
view model =
    div [class "container"]
        [topBar model
        ,mainSection model
        ]


topBar: Model -> Html Message
topBar model =
    div [class "topBar"]
        [span [] [text "top bar"]
        ]


mainSection: Model -> Html Message
mainSection model =
    div [class "mainSection"]
        [middleSection model
        ,section "Messages" <| messages model.messages]


middleSection: Model -> Html Message
middleSection model =
    div [class "middleSection"]
        [section "Map" <| drawMap model
        ,section "Stats" <| playerStats model.player
        ,section "Actions" <| actions model
        ]


drawMap: Model -> Html Message
drawMap model =
    let
        grid = model.map.grid
        {width, height} = model.map.size
    in
        div [class "mapWrapper"]
            [div [class "mapContainer"]
                 [Map.View.view model.map
                 ,renderPlayer model.player
                 ]
            ]


playerStats: Player -> Html Message
playerStats player =
    let
        {hp} = player
        header = \content -> span [class "header"] [text content]
        formattedHp = (toString hp.current) ++ "/" ++ (toString hp.max)
        kv = \key value ->
             tr []
                 [td [class "infoRowHeader"] [text key]
                 ,td [] [text value]]
        x = 1
    in
        div [class "playerInfo"]
            [div []
                 [table [class "infoRow"]
                        [kv "hp" formattedHp
                        ,kv "str" (toString player.str)
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
                    [i [class ("game-icon " ++ icon)] []
                    ,a [] [text desc]]
    in
        div [class "actions"]
            [text "stuff"
            ,div [] [text <| toString model.currentTick]
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
        {x, y} = player.location
        pixelLocation = hexCoords x y
        size = cellSize
        actualWidth = 40
        actualHeight = 50
        offsetX = pixelLocation.x + (size.width - actualWidth) / 2
        offsetY = pixelLocation.y + (size.height - actualHeight) / 2
    in
        div [class "player"
            ,style <| positionStyle actualWidth actualHeight offsetX offsetY
            ]
            [i [class "game-icon game-icon-pikeman"] []]


progressBar: Int -> Int -> Html Message
progressBar current max =
    let
        pct = ((toFloat current) / (toFloat max)) * 100
    in
        div []
            [div []
                 []]


section: String -> Html Message -> Html Message
section header content =
    div [class "section"]
        [div [class "sectionHeader"]
             [text header]
        ,div [class "sectionContent"]
             [content]]

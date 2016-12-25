module View exposing (view)


import Html exposing (..)
import Html.Attributes exposing (style, class)
import Model exposing (..)
import Messages exposing (Message)
import Grid exposing (Grid)
import Map.Utils exposing (..)
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
        [div [class "mapWrapper"]
             [drawMap model]
        ]


drawMap: Model -> Html Message
drawMap model =
    let
        grid = model.map.grid
        {width, height} = model.map.size
    in
        div [class "mapContainer"]
            [Map.View.view model.map
            ,renderPlayer model.player
            ]



-- utility functions

renderPlayer: Player -> Html Message
renderPlayer player =
    let
        {x, y} = player.location
        pixelLocation = hexCoords x y
        size = cellSize
        actualWidth = 25
        actualHeight = 40
        offsetX = pixelLocation.x + (size.width - actualWidth) / 2
        offsetY = pixelLocation.y + (size.height - actualHeight) / 2
    in
        div [class "player"
            ,style <| positionStyle actualWidth actualHeight offsetX offsetY
            ]
            [text "player"]

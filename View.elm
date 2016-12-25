module View exposing (view)


import Html exposing (..)
import Html.Attributes exposing (style, class)
import Model exposing (..)
import Messages exposing (Message)
import Grid exposing (Grid)


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
            [renderGrid model.map
            ,renderPlayer model.player
            ]



cellSizeX: Float
cellSizeX = 30


cellSizeY: Float
cellSizeY = 30


cellSize: { width: Float, height: Float }
cellSize =
    {
        -- width = cellSizeX * (sqrt (3 / 2)),
        -- height = cellSizeY * (3 / 2)
        width = cellSizeX * (3 / 2) - 1,
        height = cellSizeY * (sqrt 3) - 1
    }


toPx: Float -> String
toPx val =
    (val |> toString) ++ "px"


hexCoords: Int -> Int -> { x: Float, y: Float }
hexCoords x y =
    let
        x_ = toFloat x
        y_ = toFloat y
    in
        {
            x = cellSizeX * 3 / 2 * x_,
            y = cellSizeY * (sqrt 3) * (y_ - 0.5 * (toFloat ((round x_) % 2)))
        }


positionStyle: Float -> Float -> Float -> Float -> List (String, String)
positionStyle width height x y =
    [("width", width |> toPx)
    ,("height", height |> toPx)
    ,("left", x |> toPx)
    ,("top", y |> toPx)
    ]


renderCell: Html Message -> Float -> Float -> Html Message
renderCell contents x y =
    let
        {width, height} = cellSize
    in
        div [class "hex"
            ,style <| positionStyle width height x y
            ]
            [contents]


renderPlayer: Player -> Html Message
renderPlayer player =
    let
        {x, y} = player.location
        pixelLocation = hexCoords x y
        size = cellSize
        width = 25
        height = 40
        offsetX = (size.width - width) / 2
        offsetY = (size.height - height) / 2
    in
        div [class "player"
            ,style <| positionStyle width height (pixelLocation.x + offsetX) (pixelLocation.y + offsetY)
            ]
            [text "player"]


renderGrid: Grid Hex -> Html Message
renderGrid grid =
    let
        {width, height} = grid.size
        pixelLocation = \cell -> hexCoords cell.x cell.y
        drawCell =
            \cell ->
                let
                    {x, y} = pixelLocation cell
                    contents =
                        div []
                            [text ((cell.x |> toString) ++ (cell.y |> toString))]
                in
                    renderCell contents x y
        cells =
            grid |> Grid.toList |> List.map drawCell
    in
        div [class "map"]
            cells


renderTile: Tile -> Html Message
renderTile tile =
    div [] []

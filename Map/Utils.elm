module Map.Utils exposing (..)


cellSizeX: Float
cellSizeX = 65 / (3 / 2) -- 64 cell width


cellSizeY: Float
cellSizeY = 65 / (sqrt 3) -- to get a 64px cell height


cellSize: { width: Float, height: Float }
cellSize =
    {
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

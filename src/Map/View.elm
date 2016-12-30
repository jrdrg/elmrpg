module Map.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import Grid exposing (..)
import Map.Utils exposing (cellSize, positionStyle, hexCoords)
import Map.Model exposing (Map, Hex, Tile, Tile(..))


view: Grid Hex -> (Int, Int) -> Html Message
view grid playerLocation =
    let
        (playerX, playerY) = playerLocation
        {width, height} = grid.size
        pixelLocation = \cell -> hexCoords cell.x cell.y
        drawCell =
            \cell ->
                let
                    {x, y} = pixelLocation cell
                    distance = Grid.distance {x = cell.x, y = cell.y} { x = playerX, y = playerY }
                in
                    renderCell cell distance x y
        cells =
            grid |> Grid.toList |> List.map drawCell
    in
        div [class "map"]
            cells


renderCell: Hex -> Float -> Float -> Float -> Html Message
renderCell cell distance x y =
    let
        {width, height} = cellSize
        location = (cell.x, cell.y)
        contents = renderTileImage cell.tile location
        opacity = 1 / distance
    in
        div [class "hex"
            ,style <| ("opacity", (toString opacity)) :: positionStyle width height x y
            ,onClick <| ActionMsg (Move location)
            ]
            [contents]


renderTileImage: Tile -> (Int, Int) -> Html Message
renderTileImage tile location =
    let
        className = case tile of
                        -- Grass -> "game-icon game-icon-grass grass"
                        Grass -> "grassTile pixelImage tileImage"
                        -- Hills -> "game-icon game-icon-hills hills"
                        Hills -> "hillTile pixelImage tileImage"
                        -- _ -> "game-icon game-icon-peaks mountain"
                        _ -> "mountainTile pixelImage tileImage"
    in
        div [class "hexImg"]
            [div [class className]
                 []
            ]


renderTile: Tile -> (Int, Int) -> Html Message
renderTile tile location =
    let
        (x, y) = case tile of
                     Grass ->
                         (-192, 0)
                     Forest ->
                         (-384, 0)
                     Mountain ->
                         (-128, -64)
                     Hills ->
                         (0, -64)
                     Water ->
                         (-64, 0)
        position = (toString x) ++ "px " ++ (toString y) ++ "px"
        (locX, locY) = location
    in
        div [class "hexImg"
            ,style [("backgroundPosition", position)]
            ,onClick <| ActionMsg (Move location)
            ]
            [text ((locX |> toString) ++ (locY |> toString))]

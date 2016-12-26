module Map.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import Grid exposing (..)
import Model exposing (..)
import Map.Utils exposing (cellSize, positionStyle, hexCoords)
import Map.Model exposing (Map, Hex, Tile, Tile(..))


view: Grid Hex -> Html Message
view grid =
    let
        {width, height} = grid.size
        pixelLocation = \cell -> hexCoords cell.x cell.y
        drawCell =
            \cell ->
                let
                    {x, y} = pixelLocation cell
                in
                    renderCell cell x y
        cells =
            grid |> Grid.toList |> List.map drawCell
    in
        div [class "map"]
            cells


renderCell: Hex -> Float -> Float -> Html Message
renderCell cell x y =
    let
        {width, height} = cellSize
        location = (cell.x, cell.y)
        contents = renderTileImage cell.tile location
    in
        div [class "hex"
            ,style <| positionStyle width height x y
            ,onClick <| ActionMsg (Move location)
            ]
            [contents]


renderTileImage: Tile -> (Int, Int) -> Html Message
renderTileImage tile location =
    let
        className = case tile of
                        Grass -> "game-icon game-icon-grass grass"
                        Hills -> "game-icon game-icon-hills hills"
                        _ -> "game-icon game-icon-peaks mountain"
    in
        div [class "hexImg"]
            [i [class className]
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

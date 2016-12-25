module Map.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import Grid exposing (..)
import Model exposing (..)
import Map.Utils exposing (..)


view: Grid Hex -> Html Message
view grid =
    let
        {width, height} = grid.size
        pixelLocation = \cell -> hexCoords cell.x cell.y
        drawCell =
            \cell ->
                let
                    {x, y} = pixelLocation cell
                    contents_ =
                        div [class "hexImg"]
                            [text ((cell.x |> toString) ++ (cell.y |> toString))]
                    contents = renderTile cell.tile (cell.x, cell.y)
                in
                    renderCell contents x y
        cells =
            grid |> Grid.toList |> List.map drawCell
    in
        div [class "map"]
            cells


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
    in
        div [class "hexImg"
            ,style [("backgroundPosition", position)]
            ,onClick <| ActionMsg (Move location)
            ]
            []


renderCell: Html Message -> Float -> Float -> Html Message
renderCell contents x y =
    let
        {width, height} = cellSize
    in
        div [class "hex"
            ,style <| positionStyle width height x y
            ]
            [contents]

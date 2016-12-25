-- import Text exposing (asText)
import List exposing (map, concatMap, reverse, drop)
import Collage exposing (Form, collage, ngon, move, rotate, filled)
import Element exposing (toHtml)
import Color exposing (rgb)

import Model

--Based on http://www.redblobgames.com/grids/hexagons/

type alias Point = {
  x : Int,
  y : Int
}


-- WE STORE A GRID AS A LIST OF POINTS
type alias Grid = List Point


-- CREATE A HEX GRID WITH A GIVEN NUMBER OF LEVELS
hexGrid : Int -> Grid
hexGrid levels =
    let
        fullColumn x = map (Point x) <| List.range -levels levels
        makeColumn x =
            if x < 0 then
                drop (abs x) (fullColumn x)
                -- fullColumn x
            else if x > 0 then
                     reverse (drop (abs x) (reverse (fullColumn x)))
                     -- fullColumn x
                 else
                     fullColumn x
    in
        concatMap makeColumn <| List.range -levels levels



---CODE TO RENDER A HEX GRID----
-------
--Play with these values to see what they do
hexSize = 30
hexColor = rgb 10 150 100
hexLevels = 10
--------


hexagon = ngon 6 hexSize


-- Formula to convert axial coordinates (pointy-top) to
-- screen coordinates
toScreen: Point -> {x: Float, y: Float}
toScreen hex =
    {
        x = hexSize * (sqrt 3) * ((toFloat hex.x) + (toFloat hex.y) / 2),
        y = hexSize * 3 / 2 * (toFloat hex.y)
    }

toScreenFlat: Point -> {x: Float, y: Float}
toScreenFlat hex =
    {
        x = hexSize * 3 / 2 * (toFloat hex.x),
        y = hexSize * (sqrt 3) * ((toFloat hex.y) + (toFloat hex.x) / 2)
    }



-- Render the grid
renderGrid : Grid -> List Form
renderGrid grid =
  let
      renderHex hex =
          let
              screenHex = toScreenFlat hex
          in
              hexagon
              |> filled hexColor
              |> rotate (degrees 60)
              |> move (screenHex.x + (screenHex.x / 50), screenHex.y + (screenHex.y / 50))
  in
      map renderHex grid



grid = hexGrid hexLevels

main =
    renderGrid grid
     |> collage 1800 1000
     |> toHtml

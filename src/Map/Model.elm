module Map.Model exposing (Map, createMap)


import Array exposing (..)
import Grid exposing (Grid, initializeGrid)
import Map.Types exposing (Hex, Tile(..))


-- TODO: change this to no longer use a fixed map
-- randomly generate 6 surrounding hexes from start tile (0, 0), store coords in Dict instead of Array
-- so that they can effectively be boundless
-- store the upper-left coord and just loop through and render any tiles that exist in the Dict
-- each tile can have resources gathered from it once, this replenishes once you rest in a town (also randomly found)
-- tile types have a certain weight (grass=1, mountain=4, etc), from the sum of all weights plus the weights of the surrounding tiles
-- ALSO: switch to axial or cube coordinates instead of offset coords since this isn't using a fixed map anymore

type alias Map =
    Grid Hex


createMap: Grid Hex
createMap =
    initializeGrid makeHex 9 8


makeHex: Int -> Int -> Hex
makeHex width index =
    let
        tile = Array.get index initialMap
             |> Maybe.map numberToTile
             |> Maybe.withDefault Water
    in
        {
            tile = tile,
            x = index % width,
            y = index // width
        }


initialMap: Array Int
initialMap =
    Array.fromList
        [0, 0, 0, 0, 0, 3, 3, 3, 3
        ,0, 2, 0, 0, 0, 0, 2, 3, 3
        ,0, 0, 0, 0, 0, 2, 3, 3, 2
        ,0, 0, 0, 0, 0, 0, 2, 0, 1
        ,0, 0, 1, 1, 1, 0, 0, 0, 2
        ,0, 0, 1, 1, 0, 0, 0, 0, 3
        ,0, 0, 0, 0, 0, 0, 0, 0, 3
        ,0, 0, 0, 0, 0, 0, 0, 2, 3]


numberToTile: Int -> Tile
numberToTile key =
    case key of
        0 -> Grass
        1 -> Forest
        2 -> Hills
        3 -> Mountain
        _ -> Water

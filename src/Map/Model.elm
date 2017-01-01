module Map.Model exposing (Map, createMap)


import Array exposing (..)
import Grid exposing (..)
import Map.Types exposing (Hex, Tile(..))


type alias Map =
    Grid Hex


createMap: Grid Hex
createMap =
    initializeGrid makeHex 9 8


makeHex: Int -> Int -> Hex
makeHex width index =
    let
        tileKey = Array.get index initialMap
        tile = case tileKey of
                   Just key ->
                       numberToTile key
                   Nothing ->
                       Water
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

module Map.Types exposing (..)


import Grid


type alias Hex =
    Grid.Point
    {
        tile: Tile
    }


type Tile =
    Grass |
    Forest |
    Mountain |
    Hills |
    Water

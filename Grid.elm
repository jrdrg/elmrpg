module Grid exposing (Grid, Point, initializeGrid, toList)

import Array exposing (Array)


type alias Grid a =
    {
        grid: Array a,
        size: Size
    }


type alias Point a =
    {
        a |
        x: Int,
        y: Int
    }


type alias Size =
    {
        width: Int,
        height: Int
    }


initializeGrid: (Int -> Int -> a) -> Int -> Int -> Grid a
initializeGrid initCell width height =
    {
        grid = Array.initialize (height * width) (initCell width),
        size = { width = width, height = height }
    }


elementAt: Grid a -> Int -> Int -> Maybe a
elementAt {grid, size} x y =
    let
        index = (y * size.width) + x
        element = Array.get index grid
    in
        element


toList: Grid a -> List a
toList grid =
    Array.toList grid.grid

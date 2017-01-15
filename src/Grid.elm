module Grid exposing
    (
     Grid, Point,
     initializeGrid, toList, isNeighbor, distance
    )


import Dict exposing (Dict)


type alias Grid a =
    {
        grid: Dict (Int, Int) a,
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


initializeGrid: (Int -> Int -> Point a) -> Int -> Int -> Grid (Point a)
initializeGrid initCell width height =
    {
        grid = (cells initCell width (width * height)) |> Dict.fromList,
        size = { width = width, height = height }
    }


cells: (Int -> Int -> Point a) -> Int -> Int -> List ((Int, Int), Point a)
cells initCell width length =
    let
        keyPairs = List.range 0 length
                 |> List.map (initCell width)
                 |> List.map (\h -> ((h.x, h.y), h))
    in
        keyPairs


isNeighbor: Point a -> Point a -> Bool
isNeighbor p1 p2 =
    distance p1 p2 == 1


elementAt: Grid a -> Int -> Int -> Maybe a
elementAt {grid, size} x y =
    let
        element = Dict.get (x, y) grid
    in
        element


toList: Grid a -> List a
toList grid =
    Dict.values grid.grid


distance: Point a -> Point a -> Float
distance p1 p2 =
    let
        cube1 = offsetToCube p1
        cube2 = offsetToCube p2
    in
        cubeDistance cube1 cube2


type alias CubePoint =
    {
        x: Int,
        y: Int,
        z: Int
    }


offsetToCube: Point a -> CubePoint
offsetToCube offset =
    let
        {x, y} = offset
        x_ = toFloat x
        z_ = toFloat y - (toFloat (x + (x % 2))) / 2   --(col + (col&1)) / 2
        y_ = -x_ - z_
    in
        {
            x = round x_,
            y = round y_,
            z = round z_
        }


cubeToOffset: CubePoint -> Point {}
cubeToOffset cube =
    let
        {x, z} = cube
        x_ = x
        y_ = toFloat z + (toFloat (x + (x % 2))) / 2
    in
        {
            x = x_,
            y = round y_
        }


cubeDistance: CubePoint -> CubePoint -> Float
cubeDistance p1 p2 =
    let
        dx = abs (p1.x - p2.x)
        dy = abs (p1.y - p2.y)
        dz = abs (p1.z - p2.z)
    in
        toFloat (dx + dy + dz) / 2

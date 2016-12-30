module Grid exposing
    (
     Grid, Point,
     initializeGrid, toList, isNeighbor, distance
    )


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


isNeighbor: Point a -> Point a -> Bool
isNeighbor p1 p2 =
    distance p1 p2 == 1


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

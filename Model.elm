module Model exposing
    (
     Model,
     createModel,
     Hex, Tile, Tile(..), Player, Enemy, Resource
    )


import Array exposing (Array)
import Grid exposing (..)


type alias Model =
    {
        currentTick: Float,
        state: GameState,
        map: Grid Hex,
        player: Player
    }

type alias Hex =
    Grid.Point
    {
        tile: Tile
    }


type GameState =
    Title |
    Battle |
    Action |
    MessageDisplayed


type Tile =
    Grass |
    Forest |
    Mountain |
    Hills |
    Water


type Resource =
    Wood |
    Stone |
    Gold |
    SomethingElse


type alias Entity a =
    {
        a |
        hp: Int
    }


type alias Player =
    Entity
    {
        location: Grid.Point {},
        xp: { current: Int, next: Int }
    }


type alias Enemy =
    Entity
    {

    }



-- Init functions


createModel: Model
createModel =
    {
        currentTick = 0,
        state = Title,
        player = initializePlayer,
        map = createMap
    }


initializePlayer: Player
initializePlayer =
    {
        hp = 1,
        xp = { current = 0, next = 10 },
        location = { x = 3, y = 4 }
    }


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
        [0, 0, 0, 0, 0, 3, 3, 3
        ,0, 0, 0, 0, 0, 0, 2, 3
        ,0, 0, 0, 0, 0, 2, 3, 3
        ,0, 0, 0, 0, 0, 0, 2, 0
        ,0, 0, 1, 1, 1, 0, 0, 0
        ,0, 0, 1, 1, 0, 0, 0, 0
        ,0, 0, 0, 0, 0, 0, 0, 0
        ,0, 0, 0, 0, 0, 0, 0, 0]


numberToTile: Int -> Tile
numberToTile key =
    case key of
        0 -> Grass
        1 -> Forest
        2 -> Hills
        3 -> Mountain
        _ -> Water


createMap: Grid Hex
createMap =
    initializeGrid makeHex 8 8

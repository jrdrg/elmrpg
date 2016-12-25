module Model exposing
    (
     Model,
     createModel,
     Hex, Tile, Player, Enemy, Resource
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


makeHex: Int -> Int -> Hex
makeHex width index =
    {
        tile = Water,
        x = index % width,
        y = index // width
    }


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


createMap: Grid Hex
createMap =
    initializeGrid makeHex 8 8

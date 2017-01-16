module Model exposing
    (
     Model,
     GameState(..),
     createModel,
     Player, PlayerMovement(..),
     setPlayerLocation, moveTo
    )

import Animations.Model
import Dict exposing (Dict)
import Types exposing (..)
import Map.Model exposing (Map, createMap)
import StatusEffects exposing (StatusEffect(..))
import Combat.Model exposing (Combat)


type alias Model =
    {
        currentTick: Float,
        state: GameState,
        animations: Animations.Model.Animations,
        messages: List String,
        map: Map,
        player: Player
    }


type GameState =
    Title |
    Inventory |
    Map |
    Battle (Maybe Combat) |
    Action |
    GameOver String


type alias Player =
    Entity
    {
        level: Int,
        xp: { current: Int, next: Int },
        str: Int,
        dex: Int,
        int: Int,
        agi: Int,
        end: Int,
        location: PlayerMovement,
        mp: CurrentMax,
        food: CurrentMax,
        equipped: Equipment
    }


type alias PixelLocation = Location Float
type alias MapCoordinates = Location Int

type PlayerMovement =
    Moving PixelLocation MapCoordinates |
    CurrentLocation MapCoordinates


type alias Location a =
    {
        x: a,
        y: a
    }

-- Init functions

createModel: Model
createModel =
    {
        currentTick = 0,
        state = Map,
        animations = Animations.Model.init,
        player = initializePlayer,
        map = createMap,
        messages = List.repeat 10 "."
    }


initializePlayer: Player
initializePlayer =
    {
        level = 1,
        speed = 1,
        hp = { current = 10, max = 10 },
        mp = { current = 10, max = 10 },
        food = { current = 5, max = 20 },
        xp = { current = 0, next = 10 },
        location = CurrentLocation { x = 2, y = 3 },
        str = 5,
        dex = 7,
        int = 7,
        end = 10,
        agi = 9,
        equipped =
            {
                weapon = Nothing,
                armor = Nothing,
                ring = Nothing
            },
        status = [Normal]
    }


setPlayerLocation: Player -> Location Float -> Player
setPlayerLocation player location =
    case player.location of
        Moving pixelLocation toPoint ->
            {
                player |
                    location =
                        Moving { x = location.x, y = location.y } toPoint
            }
        _ ->
            player


moveTo: Location Int -> Player -> Player
moveTo location player =
    {
        player |
            location = CurrentLocation location
    }


weapons: Dict String Weapon
weapons =
    let
        makeWeapon = \name type_ n d mod -> { name = name, weaponType = type_, damage = { n = n, d = d, mod = mod }}
    in
        Dict.fromList
            [("shortsword", makeWeapon "Short Sword" Sword 1 6 0)
            ,("handaxe", makeWeapon "Hand Axe" Axe 1 8 1)
            ]

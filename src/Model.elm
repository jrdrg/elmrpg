module Model exposing
    (
     Model,
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
        player: Player,
        combat: Maybe Combat
    }


type alias Player =
    Entity
    {
        level: Int,
        str: Int,
        dex: Int,
        int: Int,
        agi: Int,
        end: Int,
        location: PlayerMovement,
        xp: { current: Int, next: Int },
        food: CurrentMax,
        equipped: Equipment
    }


type PlayerMovement =
    Moving (Location Float) (Location Int) |
    CurrentLocation (Location Int)


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
        messages = ["test message", "test message 2"],
        combat = Nothing
    }


initializePlayer: Player
initializePlayer =
    {
        level = 1,
        speed = 1,
        hp = { current = 7, max = 10 },
        food = { current = 70, max = 100 },
        xp = { current = 0, next = 10 },
        location = CurrentLocation { x = 3, y = 4 },
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

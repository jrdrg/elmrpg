module Model exposing
    (
     Model,
     createModel,
     Player, Enemy
    )


import Grid exposing (..)
import Dict exposing (Dict)
import Types exposing (..)
import Map.Model exposing (..)
import StatusEffects exposing (..)


type alias Model =
    {
        currentTick: Float,
        state: GameState,
        map: Map,
        player: Player,
        messages: List String
    }


type alias Weapon =
    {
        name: String,
        weaponType: WeaponType,
        damage: { n: Int, d: Int, mod: Int } -- e.g. 2d8 + 1
    }


type alias Armor =
    {
        name: String,
        ac: Int,
        damageReduction: Int
    }


type alias Ring =
    {

    }


type alias Entity a =
    {
        a |
        hp: { current: Int, max: Int },
        status: List StatusEffect
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
        location: Grid.Point {},
        xp: { current: Int, next: Int },
        equipped: Equipment
    }


type alias Equipment =
    {
        weapon: Maybe Weapon,
        armor: Maybe Armor,
        ring: Maybe Ring
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
        state = Map,
        player = initializePlayer,
        map = createMap,
        messages = ["test message", "test message 2"]
    }


initializePlayer: Player
initializePlayer =
    {
        level = 1,
        hp = { current = 6, max = 10 },
        xp = { current = 0, next = 10 },
        location = { x = 3, y = 4 },
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


weapons: Dict String Weapon
weapons =
    let
        makeWeapon = \name type_ n d mod -> { name = name, weaponType = type_, damage = { n = n, d = d, mod = mod }}
    in
        Dict.fromList
            [("shortsword", makeWeapon "Short Sword" Sword 1 6 0)
            ,("handaxe", makeWeapon "Hand Axe" Axe 1 8 1)
            ]

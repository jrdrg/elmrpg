module Types exposing (..)

import StatusEffects exposing (..)


type GameState =
    Title |
    Map |
    Battle |
    Action |
    GameOver String


type Resource =
    Wood |
    Stone |
    Gold


type WeaponType =
    Sword |
    Axe |
    Dagger |
    Ranged


type alias CurrentMax =
    {
        current: Int,
        max: Int
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


type alias Equipment =
    {
        weapon: Maybe Weapon,
        armor: Maybe Armor,
        ring: Maybe Ring
    }


type alias Entity a =
    {
        a |
        hp: CurrentMax,
        status: List StatusEffect,
        speed: Float
    }


type alias Enemy =
    Entity
    {
        key: Int,
        name: String,
        image: String,
        imageCoords: (Int, Int)
    }

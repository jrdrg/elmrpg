module Types exposing (..)

import StatusEffects exposing (..)


type GameState =
    Title |
    Map |
    Battle |
    Action |
    MessageDisplayed


type Resource =
    Wood |
    Stone |
    Gold


type WeaponType =
    Sword |
    Axe |
    Dagger |
    Ranged


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

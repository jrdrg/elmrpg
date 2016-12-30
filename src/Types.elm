module Types exposing (..)


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

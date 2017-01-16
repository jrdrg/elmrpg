module Combat.Messages exposing (..)

import Types exposing (Enemy)


type Message =
    StartBattle |
    EnemyTurn |
    EnemyAttack Int |
    PlayerTurn |
    PlayerAttack Int |
    ResolveDamage DamageTarget (Int, Int)


type DamageTarget =
    PlayerTarget (Maybe Enemy) |
    EnemyTarget Int

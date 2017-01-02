module Combat.Messages exposing (..)


type Message =
    StartBattle |
    EnemyTurn |
    EnemyAttack Int |
    PlayerTurn |
    PlayerAttack Int |
    ResolveDamage DamageTarget Int


type DamageTarget =
    PlayerTarget |
    EnemyTarget Int

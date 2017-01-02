module Combat.Messages exposing (..)


type Message =
    StartBattle |
    EnemyTurn |
    EnemyAttack Int |
    PlayerTurn |
    PlayerAttack Int |
    EnemyDamaged Int Int

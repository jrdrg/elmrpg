module Combat.Model exposing
    (
     Combat, initializeNewCombat
    )


import Types exposing (Enemy)
import StatusEffects exposing (StatusEffect(..))


type alias Combat =
    {
        enemies: List Enemy
    }



initializeNewCombat:  Combat
initializeNewCombat =
    {
        enemies = [createEnemy 0]
    }


createEnemy: Int -> Enemy
createEnemy index =
    {
        key = index,
        name = "Goblin",
        speed = 2,
        hp = initializeHp 10,
        status = [Normal],
        image = "enemyMisc",
        imageCoords = (0, -16)
    }


initializeHp: Int -> { current: Int, max: Int }
initializeHp hp =
    {
        current = hp,
        max = hp
    }

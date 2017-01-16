module Combat.Update exposing (update)


import Random
import Types exposing (CurrentMax, Enemy)
import Model exposing (Model, Player, GameState(..))
import Messages exposing (Message(..))
import Combat.Model exposing (Combat)
import Combat.Messages exposing (Message(..), DamageTarget(..))


update: Messages.Message -> Model -> Combat -> (Model, Cmd Messages.Message)
update msg model combat =
    case msg of
        CombatMsg combatMessage ->
            case model.state of
                GameOver message ->
                    model ! []
                _ ->
                    doCombat combatMessage model combat

        _ ->
            model ! []


-- Placeholder function for generating to-hit % and damage
toHitAndDamage: Int -> Int -> Random.Generator (Int, Int)
toHitAndDamage hitPct atk =
    Random.int 1 100
        |> Random.andThen (\hit -> Random.map ((,) (hit + hitPct)) (Random.int 1 atk))


generateDamageMessage: DamageTarget -> Int -> Int -> Cmd Messages.Message
generateDamageMessage target toHit damage =
    Random.generate (CombatMsg << (ResolveDamage <| target)) (toHitAndDamage toHit damage)


doCombat: Combat.Messages.Message -> Model -> Combat -> (Model, Cmd Messages.Message)
doCombat msg model combat =
    case msg of
        PlayerAttack key ->
            model ! [generateDamageMessage (EnemyTarget key) 10 5]

        ResolveDamage target (hitChance, damage) ->
            case target of
                PlayerTarget attacker ->
                    let
                        {player} = model
                        damagedPlayer = takeDamage player damage
                        newModel =
                            if isPlayerDead damagedPlayer
                            then
                                { model | state = GameOver "You died." }
                            else
                                { model | player = damagedPlayer }
                    in
                        newModel ! []

                EnemyTarget key ->
                    let
                        attacker = combat.enemies
                                 |> List.filter (\e -> e.key == key)
                                 |> List.head
                        enemiesAfterDamage = damageEnemy combat key damage
                    in
                        ({
                            model |
                                state = Battle <| Just enemiesAfterDamage
                        }
                        |> handleCombatEnded enemiesAfterDamage) ! [generateDamageMessage (PlayerTarget attacker) 4 2]
        _ ->
            model ! []


damageEnemy: Combat -> Int -> Int -> Combat
damageEnemy combat key amount =
    let
        handleDamage =
            \enemy ->
                if enemy.key == key
                then
                    takeDamage enemy amount
                else
                    enemy
    in
        {
            combat |
                enemies = List.map handleDamage combat.enemies
        }


takeDamage: { a | hp: CurrentMax } -> Int -> { a | hp: CurrentMax }
takeDamage entity value =
    let
        reduceHp = \hp -> { hp | current = hp.current - value }
    in
        { entity | hp = reduceHp entity.hp }


isPlayerDead: Player -> Bool
isPlayerDead player =
    player.hp.current <= 0


handleCombatEnded: Combat -> Model -> Model
handleCombatEnded combat model =
    let
        remainingEnemies = List.length <| List.filter (\enemy -> enemy.hp.current > 0) combat.enemies
    in
        if remainingEnemies == 0
        then
            {
                model |
                    state = Map
            }
        else
            model

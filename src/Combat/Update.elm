module Combat.Update exposing (update)


import Random
import Types exposing (CurrentMax, Enemy, GameState(..))
import Model exposing (Model)
import Messages exposing (Message(..))
import Combat.Model exposing (Combat)
import Combat.Messages exposing (Message(..), DamageTarget(..))


update: Messages.Message -> Model -> (Model, Cmd Messages.Message)
update msg model =
    case msg of
        CombatMsg combatMessage ->
            doCombat combatMessage model

        _ ->
            model ! []


doCombat: Combat.Messages.Message -> Model -> (Model, Cmd Messages.Message)
doCombat msg model =
    case msg of
        PlayerAttack key ->
            model ! [Random.generate (\dmg -> CombatMsg <| (ResolveDamage <| EnemyTarget key) dmg) (Random.int 1 5)]

        ResolveDamage target damage ->
            case target of
                PlayerTarget ->
                    model ! []

                EnemyTarget key ->
                    case model.combat of
                        Just combat ->
                            ({
                                model |
                                    combat = Just (damageEnemy combat key damage)
                            } |> handleCombatEnded) ! []
                        Nothing ->
                            model ! []
        _ ->
            model ! []


damageEnemy: Combat -> Int -> Int -> Combat
damageEnemy combat key amount =
    let
        handleDamage =
            \enemy ->
                if enemy.key == key
                then
                    {
                        enemy |
                            hp = takeDamage enemy.hp amount
                    }
                else
                    enemy
    in
        {
            combat |
                enemies = List.map handleDamage combat.enemies
        }


takeDamage: CurrentMax -> Int -> CurrentMax
takeDamage hp value =
    {
        hp |
            current = hp.current - value
    }


handleCombatEnded: Model -> Model
handleCombatEnded model =
    let
        remainingEnemies =
            case model.combat of
                Just combat ->
                    List.length <| List.filter (\enemy -> enemy.hp.current > 0) combat.enemies
                Nothing ->
                    0
    in
        if remainingEnemies == 0
        then
            {
                model |
                    state = Map,
                    combat = Nothing
            }
        else
            model

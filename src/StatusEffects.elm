module StatusEffects exposing
    (
     StatusEffect, StatusEffect(..),
     setStatus, toString
    )


type StatusEffect =
    Normal |
    Hungry |
    Starving |
    Poisoned |
    Paralyzed


setStatus: StatusEffect -> List StatusEffect -> List StatusEffect
setStatus status statuses =
    case status of
        Normal ->
            [Normal]
        _ ->
            if List.member status statuses
            then statuses
            else status :: statuses


toString: StatusEffect -> String
toString status =
    case status of
        Normal -> "Normal"
        Hungry -> "Hungry"
        Starving -> "Starving"
        Poisoned -> "Poisoned"
        Paralyzed -> "Paralyzed"

extends Node
class_name Stateful

func register_property(property: SyncProp) -> void:
    pass


func update_unstable_state() -> void:
    pass

func update_stable_state() -> void:
    pass


func is_authoritative() -> bool:
	return false

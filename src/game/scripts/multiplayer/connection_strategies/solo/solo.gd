extends ConnectionStrategy
class_name SoloConnectionStrategy

func _init():
	Debug.update_debug_property(DebugProperty.DebugPropertyKey.CONNECTION_STRATEGY_NETWORK, "Solo")

func init_connection(_network_reference: Network, _args: Dictionary):
	spawn_player(0)
	print("hllo")

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return entity_state[WorldState.STATE_KEYS.ID] != -1

func get_id() -> int:
	return 0

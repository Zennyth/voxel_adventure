extends ConnectionStrategy
class_name SoloConnectionStrategy

func _init():
	EventBus._debug_property_updated.emit(DebugProperty.DebugPropertyKey.CONNECTION_STRATEGY_NETWORK, "Solo")

func init_connection(_network_reference: Network, _args: Dictionary):
	spawn_player(0)

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return entity_state[WorldState.STATE_KEYS.ID] != -1

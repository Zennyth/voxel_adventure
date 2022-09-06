extends ServerConnectionStrategy
class_name HostConnectionStrategy

func _init():
	EventBus._debug_property_updated.emit(DebugProperty.DebugPropertyKey.CONNECTION_STRATEGY_NETWORK, "Host")

func init_connection(network: Network, args: Dictionary):
	super.init_connection(network, args)
	spawn_player()

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return entity_state[WorldState.STATE_KEYS.SCENE] != "player" \
			or entity_state[WorldState.STATE_KEYS.ID] == _network.get_id()

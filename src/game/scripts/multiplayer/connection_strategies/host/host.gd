extends ServerConnectionStrategy
class_name HostConnectionStrategy

func _init():
	Debug.update_debug_property(DebugProperty.DebugPropertyKey.CONNECTION_STRATEGY_NETWORK, "Host")

func init_connection(network: Network, args: Dictionary):
	super.init_connection(network, args)
	network._connection_succeeded.connect(spawn_player)

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return entity_state[WorldState.STATE_KEYS.SCENE] != "player" \
			or entity_state[WorldState.STATE_KEYS.ID] == _network.get_id()

func need_loaded_character() -> bool:
	return true

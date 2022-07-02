extends ConnectionStrategy
class_name SoloConnectionStrategy

func init_connection(network: Network, args: Dictionary):
	spawn_player(0)

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return entity_state[WorldState.STATE_KEYS.ID] != -1

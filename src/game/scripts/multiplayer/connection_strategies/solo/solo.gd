extends ConnectionStrategy
class_name SoloConnectionStrategy

func _ready():
#	super._ready()
#	spawn_player(0)
	pass

func init_connection(network: Network, args: Dictionary):
	pass

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return true

extends ConnectionStrategy
class_name SoloConnectionStrategy

func _ready():
	pass

func init_connection(network: Network, args: Dictionary):
	pass

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return true

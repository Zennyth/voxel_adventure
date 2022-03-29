extends Node

@onready var _players: EntitiesManager = $Players
@onready var _enemies: EntitiesManager = $Enemies

var world_state: Dictionary = {}
var world_properties: Dictionary = {}

func _physics_process(_delta: float) -> void:
	world_state = {
		"T": Time.get_ticks_msec(),
		"E": {
			"players": _players.get_entity_state_collection(),
			"enemies": _enemies.get_entity_state_collection()	
		}
	}
	
	# further processing
	get_parent().send_world_state(world_state)

func get_world_properties() -> Dictionary:
	return {
		"E": {
			"players": _players.get_entity_properties_collection(),
			"enemies": _enemies.get_entity_properties_collection()	
		}
	}

func get_entities_manager(entity_type: String) -> EntitiesManager:
	match entity_type:
		"players":
			return _players
		"enemies":
			return _enemies
		_:
			return null

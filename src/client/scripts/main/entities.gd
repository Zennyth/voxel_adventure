extends Node

@onready var _players: EntitiesManager = $Players
@onready var _enemies: EntitiesManager = $Enemies

func get_entities_manager(entity_type: String) -> EntitiesManager:
	match entity_type:
		"players":
			return _players
		"enemies":
			return _enemies
		_:
			return null

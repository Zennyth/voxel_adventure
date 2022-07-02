extends Node

@onready var Entities: EntityManager = $EntityManager

func _ready():
	EventBus._world_ready.emit(Entities)

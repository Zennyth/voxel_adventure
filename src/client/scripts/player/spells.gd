extends Node

@export
var entity: NodePath
var _entity = null
@export
var spell_list: Array[PackedScene] = []

func _ready():
	_entity = get_node(entity)

func cast_fireball(direction: Vector3) -> bool:
	if not _entity: return false
	
	var spell_instance = spell_list[0].instantiate()
	add_child(spell_instance)
	spell_instance.launch(_entity.position, direction)
	return true

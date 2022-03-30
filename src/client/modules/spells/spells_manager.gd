extends Node
class_name SpellsManager

@export
var entity: NodePath
var _entity = null

@export
var spell_list: Array[PackedScene] = []

func _ready() -> void:
	_entity = get_node(entity)


var is_fire_ball_ready = true
var timer_fireball
func fireball_ready():
	is_fire_ball_ready = true

func cast_fireball(direction: Vector3) -> bool:
	if not _entity or not is_fire_ball_ready: return false
	
	is_fire_ball_ready = false
	var spell_instance = spell_list[0].instantiate()
	
	timer_fireball = Timer.new()
	timer_fireball.set_wait_time( spell_instance.cooldown )
	timer_fireball.connect("timeout", fireball_ready) 
	add_child(timer_fireball)
	timer_fireball.start()
	
	add_child(spell_instance)
	spell_instance.launch(_entity.position, direction)
	return true

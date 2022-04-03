extends EntitiesManager

var next_enemy_id := 1 # entity_id
var max_enemy := 1
var enemy_types := ["Blank"]

@onready var _timer: Timer = $Timer

func _ready():
	_timer.set_wait_time( 5 )
	_timer.connect("timeout", spawn_enemy)
	_timer.start()

func spawn_enemy():
	if entity_state_collection.size() >= max_enemy:
		return
	
	var enemy_type = enemy_types[0]
	next_enemy_id += 1
	
	var enemy_properties = {"hp": 500, "max_hp": 500}
	var enemy_state = {"P": Vector3(-5, 4, -41), "R": Vector3(0, 0, 0)}
	
	var enemy: Character = spawn_entity(next_enemy_id) 
	enemy.set_state(enemy_state)
	enemy.update_properties()
	entity_state_collection[next_enemy_id] = enemy_state

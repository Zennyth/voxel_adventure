extends Node
class_name Stats

####
## Signals
####
signal hp_depleted

####
## Stats
####
@export var max_hp: int = 100 
@onready var hp: int = max_hp:
	get: return hp
	set(new_hp):
		hp = new_hp
		if hp <= 0: 
			hp = 0
			emit_signal("hp_depleted")
		elif hp > max_hp: hp = max_hp


####
## Main
####
var updated_stats: Array[String] = ["hp", "max_hp"]

func update_stat(key: String, value):
	if not key in self: return
	set(key, value)

func update_from_dict(new_stats: Dictionary):
	for key in new_stats.keys():
		update_stat(key, new_stats[key])

func get_to_dict(dump: Dictionary):
	for key in updated_stats:
		dump[key] = get(key)

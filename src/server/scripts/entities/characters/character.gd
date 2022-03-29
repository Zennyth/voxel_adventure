extends Entity
class_name Character

var max_hp: int = 100
var hp: int = 100

@onready var _spells_manager: SpellsManager = $SpellsManager

func _init():
	properties['hp'] = hp
	properties['max_hp'] = max_hp

func set_properties(new_properties: Dictionary) -> void:
	super(new_properties)
	
	set_health(properties['hp'])
	max_hp = properties['max_hp']

func on_hit(damage: int):
	set_health(hp - damage)
	update_properties()

func set_health(new_hp: int):
	hp = new_hp
	if hp < 0: hp = 0
	elif hp > max_hp: hp = max_hp
	properties["hp"] = hp

extends Entity
class_name Character

@onready var _model: Node3D = $Modular
@onready var _spells_manager: SpellsManager = $SpellsManager
@onready var _hp_bar: Node3D = $HealthBar

@export var max_hp: int = 100
var hp: int = 100

func _init():
	properties['hp'] = hp
	properties['max_hp'] = max_hp

func set_properties(new_properties: Dictionary) -> void:
	super(new_properties)
	
	set_health(properties['hp'])
	max_hp = properties['max_hp']

#func hit(damage: int):
#	set_health(hp - damage)

func set_health(new_hp: int):
	hp = new_hp
	if hp < 0: hp = 0
	elif hp > max_hp: hp = max_hp
	if _hp_bar: _hp_bar.update_healthbar(hp)

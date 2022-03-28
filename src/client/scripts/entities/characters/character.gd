extends Entity
class_name Character

@onready
var _model: CharacterBody3D = $Modular
@onready
var _spells_manager: SpellsManager = $SpellsManager
@onready
var _hp_bar: Sprite3D = $HealthDisplay

@export
var max_hp: int = 100
var hp: int = 100

func _init():
	properties['hp'] = hp
	properties['max_hp'] = max_hp

func update_properties(updated_properties: Dictionary) -> void:
	super(updated_properties)
	
	hp = properties['hp']
	max_hp = properties['max_hp']

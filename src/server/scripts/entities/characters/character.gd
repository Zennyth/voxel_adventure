extends Entity
class_name Character

@onready var _spells_manager: SpellsManager = $SpellsManager
@onready var _stats: Stats = $Stats

func _init():
	set_properties(properties)

func set_properties(new_properties: Dictionary) -> void:
	super(new_properties)
	
	if _stats: _stats.update_from_dict(new_properties)

func get_properties() -> Dictionary:
	if _stats: _stats.get_to_dict(properties)
	
	return properties

func on_hit(damage: int):
	set_health(_stats.hp - damage)
	update_properties()

func set_health(new_hp: int):
	_stats.hp = new_hp

func _on_stats_hp_depleted():
	queue_free()

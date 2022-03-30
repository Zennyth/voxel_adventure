extends Entity
class_name Character

####
## Signals
####
func _on_stats_hp_depleted():
	emit_signal("destroyed", id)



@onready var _model: Node3D = $Modular
@onready var _spells_manager: SpellsManager = $SpellsManager
@onready var _stats: Stats = $Stats

func _init():
	set_properties(properties)

func set_properties(new_properties: Dictionary) -> void:
	super(new_properties)
	
	# set stats
	if _stats: 
		_stats.update_from_dict(new_properties)

func get_properties() -> Dictionary:
	# set stats
	if _stats: 
		_stats.get_to_dict(properties)
	
	return properties

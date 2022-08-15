extends Stateful
class_name Component

###
# BUILT-IN
###
var entity: Entity

func init(linked_entity: Entity) -> void:
	entity = linked_entity
	_entity_initialized.emit()
	
	for component in get_children():
		if component.has_method("init"):
			component.init(entity)
	

func entity_ready() -> void:
	for component in get_children():
		if component.has_method("entity_ready"):
			component.entity_ready()


func update_unstable_state() -> void:
	entity.update_unstable_state()

func update_stable_state() -> void:
	entity.update_stable_state()


func is_authoritative() -> bool:
	return entity and entity.is_authoritative()


###
# BUILT-IN
# Properties
###
func register_property(property: Property) -> bool:
	return entity != null and entity.register_property(property)

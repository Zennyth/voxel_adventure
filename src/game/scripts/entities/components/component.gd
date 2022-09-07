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


func update_unstable_state() -> void:
	entity.update_unstable_state()

func update_stable_state() -> void:
	entity.update_stable_state()

func get_owner_id() -> int:
	return entity.get_owner_id() if entity != null else super.get_owner_id()


###
# BUILT-IN
# Properties
###
func register_property(property: Property) -> bool:
	return entity != null and entity.register_property(property)

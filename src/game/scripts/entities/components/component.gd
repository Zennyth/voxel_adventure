extends Stateful
class_name Component

####
## BUILT-IN
####
var entity: Entity

func init(linked_entity: Entity) -> void:
	entity = linked_entity
	
	for component in get_children():
		if component.has_method("init"):
			component.init(entity)


func register_property(property: SyncProp) -> void:
    entity.register_property(property)


func update_unstable_state() -> void:
	entity.update_unstable_state()

func update_stable_state() -> void:
	entity.update_stable_state()


func is_authoritative() -> bool:
	return entity and entity.is_authoritative()

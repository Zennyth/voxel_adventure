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


func get_unstable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	return super.get_unstable_state(state, component)

func set_unstable_state(new_state: Dictionary, component: Node = self) -> void:
	super.set_unstable_state(new_state, component)

func update_unstable_state() -> void:
	entity.update_unstable_state()


func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	super.set_stable_state(new_state, component)

func update_stable_state() -> void:
	entity.update_stable_state()


func is_authoritative() -> bool:
	return entity and entity.is_authoritative()

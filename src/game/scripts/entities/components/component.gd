extends Stateful
class_name Component

###
# BUILT-IN
###
var entity: Entity

func init(linked_entity: Entity) -> void:
	entity = linked_entity
    _register_properties()
	
	for component in get_children():
		if component.has_method("init"):
			component.init(entity)


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
var unregistered_properties := []

func register_property(property: SyncProperty) -> void:
    if entity:
        entity.register_property(property)
        return
    
    properties.append(property)

func _register_properties() -> void:
    for property in unregistered_properties:
        entity.register_property(property)
    
    unregistered_properties = []
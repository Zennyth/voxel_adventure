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
var unregistered_properties := {}

func get_property(key: String, is_stable: bool) -> SyncProperty:
	if key in unregistered_properties:
		return unregistered_properties[key]
	
	if entity == null:
		return null
	
	return entity.get_property(key, is_stable)

func register_property(property: SyncProperty) -> void:
	if entity:
		entity.register_property(property)
		return
	
	unregistered_properties[property.key] = property

func _register_properties() -> void:
	for property in unregistered_properties.values():
		entity.register_property(property)
	
	unregistered_properties = {}

extends Stateful
class_name Entity

###
# Signals
###
signal _destroyed(entity_id: int)


###
# BUILT-IN
###
var id: int = -1
var scene: String = ""

func get_identity() -> Dictionary:
	return {
		WorldState.STATE_KEYS.ID: id,
		WorldState.STATE_KEYS.SCENE: scene
	}

func init(entity_state: Dictionary) -> void:
	if WorldState.STATE_KEYS.ID in entity_state:
		id = entity_state[WorldState.STATE_KEYS.ID]
		scene = entity_state[WorldState.STATE_KEYS.SCENE]
		name = str(id)

	for component in get_children():
		if component.has_method("init"):
			component.init(self)

func entity_ready() -> void:
	for component in get_children():
		if component.has_method("entity_ready"):
			component.entity_ready()

func _ready():
	entity_ready()
	
	if is_authoritative():
		# Spawn the entity
		update_stable_state()

func is_authoritative() -> bool:
	return Game.multiplayer_manager.is_entity_authoritative(get_identity())


###
# BUILT-IN
# Properties
###

# key = is_stable
var properties = {
	true: PropertyManager.new(self, _stable_property_value_changed)
	false: PropertyManager.new(self)
}

func register_property(property: Property) -> void:
	properties[property.is_stable].register_property(property)

func _stable_property_value_changed(property: Property):
	if not is_authoritative():
		return
	
	var new_state = {
		WorldState.STATE_KEYS.ID: id,
		WorldState.STATE_KEYS.SCENE: scene,
		property.key: property.dump()
	}
	Game.multiplayer_manager.update_entity_stable_state(new_state)

###
# BUILT-IN
# States
###
func get_unstable_state(state: Dictionary = { }) -> Dictionary:
	state[WorldState.STATE_KEYS.ID] = id
	return properties[false].get_state()

func set_unstable_state(new_state: Dictionary) -> void:
	return properties[false].set_state(new_state)

func update_unstable_state() -> void:
	if not is_authoritative():
		return
	
	Game.multiplayer_manager.update_entity_unstable_state(get_unstable_state())


func get_stable_state(state: Dictionary = { }) -> Dictionary:
	state[WorldState.STATE_KEYS.ID] = id
	state[WorldState.STATE_KEYS.SCENE] = scene
	return properties[true].get_state()

func set_stable_state(new_state: Dictionary) -> void:
	return properties[true].set_state(new_state)

func update_stable_state() -> void:
	if not is_authoritative():
		return
	
	Game.multiplayer_manager.update_entity_stable_state(get_stable_state())


class PropertyManager:
	var property_groups := {}
	var entity: Entity
	var _property_value_changed: Callable

	func _init(_entity: Entity, property_value_changed: Callable = null):
		entity = _entity
		_property_value_changed = property_value_changed
	
	func get_groups() -> Array:
		return property_groups.keys()
	

	func set_state(new_state: Dictionary) -> void:
		for key in get_groups():
			if not key in new_state:
				continue
			
			for property in property_groups[key].
				property.parse(new_state[key])
	
	func get_state(state: Dictionary = { }) -> Dictionary:
		for key in get_groups():
			if not key in new_state:
				continue
			
			state[key] = property_groups[key][0].dump()
	
		return state
				

	func register_property(property: Property):
		if not property.key in property_groups:
			property_groups[property.key] = []
		
		if property_groups[property.key].length() == 0 or not property.ignore_duplicates:
			property._property_changed.connect(_property_changed)

		property_groups[property.key].append(property)
	
	func _property_changed(property: Property):
		for _property in property_groups[property.key]:
			if property == _property:
				continue

			_property.set_value(property.get_value())
		
		if _property_value_changed:
			_property_value_changed.emit(property)

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

func _ready():
	if is_authoritative():
		# Spawn the entity
		update_stable_state()

func is_authoritative() -> bool:
	return Game.multiplayer_manager.is_entity_authoritative(get_identity())


###
# BUILT-IN
# Properties
###
var stable_properties := {}
var unstable_properties := {}

func register_property(property: SyncProperty) -> void:
	var properties: Dictionary = stable_properties if property.is_stable else unstable_properties
	properties[property.key] = property
	
	property._sync_property_changed.connect(_sync_property_changed)

func _sync_property_changed(property: SyncProperty):
	if not is_authoritative():
		return
	
	if property.is_stable:
		update_stable_state()

###
# BUILT-IN
# States
###
func get_unstable_state(state: Dictionary = { }) -> Dictionary:
	state[WorldState.STATE_KEYS.ID] = id
	return get_state(unstable_properties, state)

func set_unstable_state(new_state: Dictionary) -> void:
	return set_state(unstable_properties, new_state)

func update_unstable_state() -> void:
	if not is_authoritative():
		return
	
	Game.multiplayer_manager.update_entity_unstable_state(get_unstable_state())


func get_stable_state(state: Dictionary = { }) -> Dictionary:
	state[WorldState.STATE_KEYS.ID] = id
	state[WorldState.STATE_KEYS.SCENE] = scene
	return get_state(stable_properties, state)

func set_stable_state(new_state: Dictionary) -> void:
	return set_state(stable_properties, new_state)

func update_stable_state() -> void:
	if not is_authoritative():
		return
	
	Game.multiplayer_manager.update_entity_stable_state(get_stable_state())


###
# UTILS
###
func get_state(properties: Dictionary, state: Dictionary = { }) -> Dictionary:
	for property in properties.values():
		state[property.key] = property.dump()

	return state

func set_state(properties: Dictionary, new_state: Dictionary) -> void:
	for property in properties.values():
		property.parse(new_state[property.key])

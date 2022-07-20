extends Stateful
class_name Entity

####
## Signals
####
signal _destroyed(entity_id: int)


####
## BUILT-IN
####
var id: int = -1
var scene: String = ""

var stable_properties := {}
var unstable_properties := {}

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


func register_property(property: SyncProp) -> void:
    var properties: Dictionary = stable_properties if property.is_stable else unstable_properties
    properties[property.key] = property


func get_unstable_state(state: Dictionary = { }) -> Dictionary:
    return get_state(state, unstable_properties)

func set_unstable_state(new_state: Dictionary) -> void:
	return set_state(state, unstable_properties)

func update_unstable_state() -> void:
	Game.multiplayer_manager.update_entity_unstable_state(get_unstable_state())


func get_stable_state(state: Dictionary = { }) -> Dictionary:
	state[WorldState.STATE_KEYS.ID] = id
	state[WorldState.STATE_KEYS.SCENE] = scene
	return get_state(state, stable_properties)

func set_stable_state(new_state: Dictionary) -> void:
	return set_state(state, stable_properties)

func update_stable_state() -> void:
	Game.multiplayer_manager.update_entity_stable_state(get_stable_state())


func is_authoritative() -> bool:
	return Game.multiplayer_manager.is_entity_authoritative(get_stable_state())



####
## UTILS
####
func get_state(state: Dictionary = { }, properties: Dictionary) -> Dictionary:
    for property in properties.values():
        state[property.key] = property.get_property()
    
    return state

func set_state(new_state: Dictionary, properties: Dictionary) -> void:
	for property in properties.values():
        property.set_property(new_state[property.key])
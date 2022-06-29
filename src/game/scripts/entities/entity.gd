extends Stateful
class_name Entity

####
## Signals
####
signal destroyed(entity_id: int)


####
## BUILT-IN
####

var id: int = -1
var scene: String = "" 

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


func get_unstable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	state[WorldState.STATE_KEYS.ID] = id
	return super.get_unstable_state(state, component)

func set_unstable_state(new_state: Dictionary, component: Node = self) -> void:
	super.set_unstable_state(new_state, component)

func update_unstable_state() -> void:
	pass #Multiplayer.update_entity_unstable_state(get_unstable_state())


func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	state[WorldState.STATE_KEYS.ID] = id
	state[WorldState.STATE_KEYS.SCENE] = scene
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	super.set_stable_state(new_state, component)

func update_stable_state() -> void:
	pass # Multiplayer.update_entity_stable_state(get_stable_state())


func is_authoritative() -> bool:
	return false
	# return Multiplayer.is_entity_authoritative(get_stable_state())

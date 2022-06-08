extends Component
class_name LabelComponent

var label: Label3D

func set_text(text: String):
	if not label:
		return
	
	label.text = str(text)
	
	if is_authoritative(): 
		update_stable_state()

func _init():
	label = $"." as Label3D





func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	state[WorldState.STATE_KEYS.LABEL] = label.text

	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	for key in new_state.keys():
		match key:
			WorldState.STATE_KEYS.LABEL:
				set_text(new_state[WorldState.STATE_KEYS.LABEL])
	
	super.set_stable_state(new_state, component)

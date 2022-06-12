extends Body
class_name Humanoid

var chest_plate
var chest_amulet

var head_face
var head_left_eye
var head_right_eye
var head_helmet

var right_foot_shoe

var left_foot_shoe

var left_hand_glove
var left_hand_weapon

var right_hand_glove
var right_hand_weapon

func _init():
	super._init()
	
	

func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:

	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	for key in new_state.keys():
		match key:
			WorldState.STATE_KEYS.LABEL:
				pass
	
	super.set_stable_state(new_state, component)

extends State
class_name CharacterState

var character_controller: Controller
var character_body: Character

var animation_state_machine

func init_state(linked_character_controller: Controller):
	character_controller = linked_character_controller
	character_body = character_controller.get_controllable()
	animation_state_machine = character_body.get_node("Body").animation_tree.get("parameters/playback")

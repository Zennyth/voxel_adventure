extends State
class_name CharacterState

var character_controller: Controller
var character_body: Character

func init_state(linked_character_controller: Controller):
	character_controller = linked_character_controller
	character_body = character_controller.get_controllable()

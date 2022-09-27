extends Control
class_name SequenceMenu


var is_previous: bool:
	get:
		return Launch.screen_command_manager.has_redo

var skip: bool:
	get:
		return skip_condition()


func _init():
	if !is_previous and skip:
		next_screen(logical_next_screen())

func next_screen(scene: PackedScene):
	Launch.screen_command_manager.execute(RedirectSceneCommand.new(self, scene))

func previous_screen():
	Launch.screen_command_manager.undo()

func logical_next_screen() -> PackedScene:
	return null

func skip_condition() -> bool:
	return false
